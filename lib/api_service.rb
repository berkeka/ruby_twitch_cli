require 'launchy'
require 'httparty'

require_relative 'constants'

class ApiService
  attr_accessor :code, :access_token, :refresh_token, :user_id

  def make_request
    request_url = "#{BASE_AUTH_URL}/authorize?client_id=#{CLIENT_ID}&redirect_uri=#{REDIRECT_URI}&response_type=code&scope=user:read:email"
    Launchy.open(request_url)
  end

  def get_token
    request_url = "#{BASE_AUTH_URL}/token?client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&code=#{@code}&grant_type=authorization_code&redirect_uri=http://localhost:8000"

    response = HTTParty.post(request_url)
    @refresh_token = response['refresh_token']
    @access_token = response['access_token']
  end

  def refresh_token
    
  end

  def get_user
    # Get userid from username
    module_url = "/users?login=#{USERNAME}"
    request_url = "#{BASE_API_URL}#{module_url}"
    headers = {
      "Client-ID" => CLIENT_ID,
      "Authorization" => "Bearer #{@access_token}"
    }
    response = HTTParty.get(request_url, headers: headers)
    data = response['data']

    @user_id = data.first['id']
  end

  def get_followed_streamers
    # Currently returns maximum of 100 followed users
    module_url = "/users/follows?from_id=#{user_id}&first=100"
    request_url = "#{BASE_API_URL}#{module_url}"
    headers = {
      "Client-ID" => CLIENT_ID,
      "Authorization" => "Bearer #{@access_token}"
    }
    response = HTTParty.get(request_url, headers: headers)
    data = response['data']
    streamers = []
    data.each do |streamer|
      streamers << { id: streamer['to_id'], name: streamer['to_name']} 
    end
    streamers
  end
end