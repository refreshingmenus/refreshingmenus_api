require 'refreshingmenus_api/version'
require 'refreshingmenus_api/widget'

require 'api_smith'

module RefreshingmenusApi

  class ApiError < StandardError;
  end
  class NotFoundError < ApiError;
  end
  class UnprocessableEntityError < ApiError;
  end

  class Menu < APISmith::Smash
  
    class Entry < APISmith::Smash

      class Price < APISmith::Smash
        property :position
        property :title
        property :price
        property :unit
        property :currency
      end

      property :type
      property :position
      property :title
      property :desc

      # Item specific
      property :restrictions
      property :spiciness

      # Price info
      property :prices, :transformer => Entry::Price

      # Sub-Entries
      property :entries, :transformer => Entry
    end

    property :guid, :from => :id
    property :title
    property :desc
    property :position
    property :entries, :transformer => Menu::Entry

    # FIXME: What is the proper way to do this?
    def fetch!(client)
      client.menu(self.guid)
    end

  end

  class Place < APISmith::Smash
    property :guid, :from => :id
    property :name
    property :street
    property :zip
    property :country_code
    property :lat
    property :lng
    property :normalized_phone
    property :menus_count
    property :menus, :transformer => Menu
  end

  # class PlaceCollection < APISmith::Smash
  #   property :dates, :transformer => lambda { |c| c.map { |v| TallyStat.call(v['items']) }.flatten }
  # end

  # Usage:
  # api = RefreshingmenusApi::Client.new(:auth_token => 'your_auth_token_here')
  # api.places(:q => 'some query')
  class Client

    ERRORS = {
        404 => NotFoundError,
        422 => UnprocessableEntityError,
    }
    ERRORS.default = ApiError

    include APISmith::Client

    attr_reader :auth_token, :version, :locale

    # Options:
    # * :auth_token - Your RefreshingMenus Authentication token (API)
    # * :version - Version (defaults to 1)
    # * :locale - The language (defaults to 'nl')
    def initialize(options = {})
      @auth_token = options[:auth_token]
      @version = options[:version] || '1'
      @locale = options[:locale] || 'nl'

      self.class.base_uri(options[:base_uri] || 'www.refreshingmenus.com')
      self.class.endpoint("api/v#{version}")

      add_query_options!(:auth_token => auth_token)
      add_query_options!(:locale => locale)
    end

    def places(options)
      raise ArgumentError, "Expected options to be a Hash, got #{options.inspect}." if not options.is_a?(Hash)
      get('places.json', :extra_query => options, :transform => Place)
    end

    def menu(guid)
      raise ArgumentError, "Expected guid to be a String, got #(guid.inspect}." if not guid.is_a?(String)
      get("menus/#{guid}.json", :transform => Menu)
    end

  private
   
    def check_response_errors(response)
      # In 2XX range is success otherwise it's probably error (3XX redirects range is handled by HTTParty).
      # In case of error we lookup error class or default to ApiError.
      if not (200..299).include?(response.code)
        raise ERRORS[response.code], "Got HTTP code #{response.code} (#{response.message}) from API."
      end

      # # TODO: Check JSON for error
      # if response.first.is_a?(Hash) and (error = response.first['error'])
      #   raise Error.new(error)
      # end
    end
   
  end # Client

end
