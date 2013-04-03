require 'spec_helper'

class Capistrano::Configuration
  def _cset(name, *args, &block)
    unless exists?(name)
      set(name, *args, &block)
    end
  end
end

describe Capistrano::Campystrano do
  let(:user) { `whoami` }
  let(:application) { 'my_app' }
  let(:rails_env) { Rails.env.to_s }
  let(:branch) { 'my_branch' }
  let(:campfire_emoji) { ':neckbeard:' }
  let(:campfire_settings) do
    {
      subdomain: 'mySubdomain',
      room: 'RedRoom',
      token: 'myT0k3n'
    }
  end
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

      Capistrano::Campystrano.load_into(c)
    end
  end

  shared_examples_for 'config' do
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
      Tinder::Campfire.should_receive(:new).with(campfire_settings[:subdomain], token: campfire_settings[:token]).and_return(campfire)
      subject
    end
  end

  describe 'deploy:campystrano:start task' do
    subject do
      config.find_and_execute_task('deploy:campystrano:start')
    end

    it_behaves_like 'config'

    it 'sends a message to Campfire' do
      msg = "#{user} deploying #{branch} to #{application} #{rails_env}"
      room.should_receive(:speak).with("#{campfire_emoji}#{msg}#{campfire_emoji}")
      subject
    end
  end

  describe 'deploy:campystrano:success task' do
    subject do
      config.find_and_execute_task('deploy:campystrano:success')
    end

    it_behaves_like 'config'

    it 'sends a message to Campfire' do
      msg = "Deploy to #{application} #{rails_env} finished successfully"
      room.should_receive(:speak).with("#{campfire_emoji}#{msg}#{campfire_emoji}")
      subject
    end
  end
end
