require 'tinder'

module Capistrano
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
          _cset(:campy_branch)                     { fetch(:branch) }
          _cset(:campfire) do
            options = symbolize_keys!(YAML.load_file(fetch(:campy_config_file)))
            puts options.inspect
            puts '========================================'
            subdomain = options.delete(:subdomain)
            room = options.delete(:room)


            campfire = Tinder::Campfire.new(subdomain, options)
            campfire.find_room_by_name(room)
          end
        end

        before 'deploy', TASKS[:start]
        after  'deploy', TASKS[:finish]

        def speak_to_campfire(msg)
          campfire.speak ":sparkles:#{msg}:sparkles:"
        end

        def symbolize_keys!(hash)
          hash.keys.each do |key|
            hash[(key.to_sym rescue key) || key] = hash.delete(key)
          end
          hash
        end

        namespace :deploy do
          namespace :campystrano do
            desc 'Report deploy start to campfire'
            task 'start' do
              speak_to_campfire("Deploying #{campy_branch} to #{campy_application} #{campy_app_env}")
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
end

if Capistrano::Configuration.instance
  Capistrano::Campystrano.load_into(Capistrano::Configuration.instance(:must_exist))
end
