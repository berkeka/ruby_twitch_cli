require 'json'

class StorageService
  class << self
    def get_values
      file = File.read('secrets.json')
      JSON.parse file
    end
  
    def set_values access_token, refresh_token
      File.write('secrets.json', JSON.pretty_generate({"access_token" => access_token, "refresh_token" => refresh_token}))
    end
  end
end