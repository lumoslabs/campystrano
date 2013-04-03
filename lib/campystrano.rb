require 'capistrano'
require 'tinder'

module Campystrano
  TASKS = {
    start: 'deploy:campystrano:start',
    success: 'deploy:campystrano:success'
  }

  def self.load_into(configuration)
    configuration.load do

      before(TASKS.values) do
        _cset(:campy_application)                { fetch(:application) }
        _cset(:campy_app_env)                    { fetch(:rails_env) }
        _cset(:campy_branch)                     { fetch(:branch) rescue '' }
        _cset(:campy_user)                       { `whoami` rescue '' }
        _cset(:campy_emoji)                      { fetch(:campfire_emoji) rescue ':sparkles:' }
        _cset(:campfire_settings)                { raise 'Campfire Settings are required' }
        _cset(:campfire) do
          options = fetch(:campfire_settings)
          subdomain = options.delete(:subdomain)
          room = options.delete(:room)

          campfire = Tinder::Campfire.new(subdomain, options)
          campfire.find_room_by_name(room)
        end
      end

      before 'deploy', TASKS[:start]
      after  'deploy', TASKS[:success]

      def speak_to_campfire(msg)
        campfire.speak "#{campy_emoji}#{msg}#{campy_emoji}"
      end

      namespace :deploy do
        namespace :campystrano do
          desc 'Report deploy start to campfire'
          task 'start' do
            speak_to_campfire("#{campy_user} deploying #{campy_branch} to #{campy_application} #{campy_app_env}")
          end

          desc 'Report deploy success to campfire'
          task 'success' do
            speak_to_campfire("Deploy to #{campy_application} #{campy_app_env} finished successfully")
          end
        end
      end

    end
  end
end

if Capistrano::Configuration.instance
  Campystrano.load_into(Capistrano::Configuration.instance(:must_exist))
end
