require 'refreshingmenus_api/version'

require 'httparty'
require 'active_support/core_ext'
require 'active_support/core_ext/hash'

module RefreshingmenusApi

  class ApiError < StandardError;
  end
  class NotFoundError < ApiError;
  end
  class UnprocessableEntityError < ApiError;
  end

  # Usage:
  # api = RefreshingmenusApi::Client.new(:auth_token => 'your_auth_token_here')
  # api.places(:q => 'some query')
  class Client

    ERRORS = {
        404 => NotFoundError,
        422 => UnprocessableEntityError,
    }
    ERRORS.default = ApiError

    include HTTParty

    attr_reader :auth_token, :version, :format

    def initialize(options = {})
      @auth_token = options[:auth_token]
      @version = options[:version] || '1'
      self.class.base_uri(options[:base_uri] || 'www.refreshingmenus.com')
    end

    def places(options)
      get('places.json', :query => options)
    end

    def get(*args)
      request :get, *args
    end

  private

    def request(method, path, options = {})
      options[:query] ||= {}
      options[:query][:auth_token] ||= auth_token
      path = File.join("/api/v#{version}", path)
      response = self.class.send(method, path, options)

      # In 2XX range is success otherwise it's probably error (3XX redirects range is handled by HTTParty).
      # In case of error we lookup error class or default to ApiError.
      case response.code
      when 200..299
        result = response.parsed_response
        result = result.collect {|r| r.is_a?(Hash) ? r.with_indifferent_access : r} if result.is_a?(Array)
        return result
      else
        raise ERRORS[response.code], "Got HTTP code #{response.code} (#{response.message}) from API.\nPath: #{path} #{options.inspect}\nAuthToken: #{auth_token}"
      end
    end

  end

end
