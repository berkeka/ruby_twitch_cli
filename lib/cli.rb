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
          if(api_service.access_token && api_service.is_authorized?)
            puts "App is already authorized"
          else
            # Either no access token is present or it is expired
            puts "Access token required."
            http_service = HttpService.new
            Thread.new {
              api_service.get_authorization
            }
            code = http_service.get_code
            if(code)
              api_service.code = code
              api_service.get_token
              puts "Authorization succesful. You can close the browser"
            else
              puts "An error occurred."
            end
          end
        end
      end

      register "version", Version, aliases: ["v", "-v", "--version"]
      register "auth",    Authorize
    end
  end
end