require 'spec_helper'

# include #_cset since it's not automatically included in Capistrano::Configuration
class Capistrano::Configuration
  def _cset(name, *args, &block)
    unless exists?(name)
      set(name, *args, &block)
    end
  end
end

describe Campystrano do
  let(:user) { 'glen_morangie' }
  let(:application) { 'my_app' }
  let(:rails_env) { Rails.env.to_s }
  let(:branch) { 'my_branch' }
  let(:campfire_emoji) { ':neckbeard:' }
  let(:subdomain) { 'mySubdomain' }
  let(:room_name) { 'RedRoom' }
  let(:token) { 'myT0k3n' }
  let(:campfire_settings) { { subdomain: subdomain, room: room_name, token: token } }
  let(:room) { mock('room', speak: 'spoken') }
  let(:campfire) { mock('campfire', find_room_by_name: room) }

  let!(:config) do
    Capistrano::Configuration.new.tap do |c|
      c.set(:application) { application }
      c.set(:rails_env) { rails_env }
      c.set(:branch) { branch }
      c.set(:campfire_emoji) { campfire_emoji }
      c.set(:campfire_settings) { campfire_settings }

      Tinder::Campfire.stub(:new).and_return(campfire)
      c.stub(:`).with('whoami').and_return(user)

      Campystrano.load_into(c)
    end
  end

  subject { config.find_and_execute_task(task) }

  shared_examples_for 'a campystrano deploy task' do
    context 'configuration' do
      it 'defines the application' do
        subject
        config.fetch(:campy_application).should == application
      end

      it 'defines the app env' do
        subject
        config.fetch(:campy_app_env).should == rails_env
      end

      it 'defines the user' do
        subject
        config.fetch(:campy_user).should == user
      end

      it 'defines the branch' do
        subject
        config.fetch(:campy_branch).should == branch
      end

      it 'defines the emoji' do
        subject
        config.fetch(:campfire_emoji).should == campfire_emoji
      end

      it 'creates a Campfire connection' do
        Tinder::Campfire.should_receive(:new).with(subdomain, token: token).and_return(campfire)
        subject
      end
    end
  end

  describe 'deploy:campystrano:start task' do
    let(:task) { 'deploy:campystrano:start' }

    it_behaves_like 'a campystrano deploy task'

    it 'sends a message to Campfire' do
      msg = "#{user} deploying #{branch} to #{application} #{rails_env}"
      room.should_receive(:speak).with("#{campfire_emoji}#{msg}#{campfire_emoji}")
      subject
    end

    it 'adds itself to the before deploy callback queue' do
      config.callbacks[:before].detect{ |cb| cb.is_a?(Capistrano::TaskCallback) }.source.should == task
    end
  end

  describe 'deploy:campystrano:success task' do
    let(:task) { 'deploy:campystrano:success' }

    it_behaves_like 'a campystrano deploy task'

    it 'sends a message to Campfire' do
      msg = "Deploy to #{application} #{rails_env} finished successfully"
      room.should_receive(:speak).with("#{campfire_emoji}#{msg}#{campfire_emoji}")
      subject
    end

    it 'adds itself to the after deploy callback queue' do
      config.callbacks[:after].detect{ |cb| cb.is_a?(Capistrano::TaskCallback) }.source.should == task
    end
  end
end
