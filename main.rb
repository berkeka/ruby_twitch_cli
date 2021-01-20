require_relative 'lib/cli'

Dry::CLI.new(Twitch::CLI::Commands).call