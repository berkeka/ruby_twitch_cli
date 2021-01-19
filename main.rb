require_relative 'http_service'
require_relative 'api_service'

http_service = HttpService.new
api_service = ApiService.new

Thread.new {
  api_service.make_request
}
code = http_service.get_code
api_service.code = code

api_service.get_token
api_service.get_user

p api_service.get_followed_streamers




