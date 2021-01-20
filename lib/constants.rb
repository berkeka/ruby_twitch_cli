require 'json'

# Read config file
file = File.read('config.json')
data = JSON.parse(file)

# Base info
BASE_AUTH_URL = 'https://id.twitch.tv/oauth2'
BASE_API_URL = 'https://api.twitch.tv/helix'
CLIENT_ID = data['client_id']
CLIENT_SECRET = data['client_secret']
USERNAME = data['username']
REDIRECT_URI = data['redirect_uri']