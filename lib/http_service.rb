require 'socket'
require 'cgi'

class HttpService
  attr_accessor :server

  def initialize
    @server = TCPServer.new 8000
  end

  def get_code
    code = nil
    loop do
      session = @server.accept
      # Raw response can contain multiple lines of GET requests
      raw_response = session.gets
      # If raw response is nil we return
      return nil unless raw_response
      line = raw_response.split("\n").first
      # Line looks like GET /?code=CODE_HERE&scope=viewing_activity_read HTTP/1.1
      # We need to get rid of some parts 
      response_url = line.chomp(" HTTP/1.1\r").reverse.chomp("GET /?".reverse).reverse
      params = CGI::parse(response_url)

      if params.key? "code"
        code = params['code'].first

        session.puts <<-HEREDOC
        HTTP/1.1 200 OK
        
        Step completed. You can close the browser.
        HEREDOC
        session.close
        break
      end
    end
    code
  end
end