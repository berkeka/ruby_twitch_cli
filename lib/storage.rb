require 'json'

class StorageService
  class << self
    def get_values
      file = File.read('secrets.json')
      JSON.parse file
    end
  
    def set_values hash
      File.write('secrets.json', JSON.pretty_generate(hash))
    end
  end
end