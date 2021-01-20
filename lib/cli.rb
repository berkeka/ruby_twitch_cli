#!/usr/bin/env ruby
require "bundler/setup"
require 'dry/cli'

require_relative 'http_service'
require_relative 'api_service'

module Twitch
  module CLI
    module Commands
      extend Dry::CLI::Registry

      class Version < Dry::CLI::Command
        desc "Print version"

        def call(*)
          puts "0.0.1"
        end
      end

      class Authorize < Dry::CLI::Command
        desc "Authorize cli app"

        def call(input: nil, **)
          api_service = ApiService.new
          if(api_service.access_token && api_service.check_auth)
            puts "App is already authorized"
          else
            # Either no access token is present or it is expired
            puts "Access token required."
          end
        end
      end

      register "version", Version, aliases: ["v", "-v", "--version"]
      register "auth",    Authorize
    end
  end
end