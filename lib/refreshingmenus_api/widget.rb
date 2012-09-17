module RefreshingmenusApi
  class Widget

    # Options:
    # * widget_token (required) - Your RefreshingMenus Widget token
    # * place_id (required) - The RefreshingMenus Place ID (UUID)
    # * secure - Boolean, we'll use https if true
    # * style - The style name we should use (default: 'default'), use 'none' for no styling (if you embed your own styling)
    def self.tag(options)
      raise ArgumentError, "Expected options argument to be a Hash, got #{options.inspect}." if not options.is_a?(Hash)
      options[:dom_id] = 'rm-menuwidget'
      raise ArgumentError, "Expected a :place_id as option but got #{options[:place_id].inspect}." if not options[:place_id].is_a?(String)
      raise ArgumentError, "Expected a :widget_token as option but got #{options[:widget_token].inspect}." if not options[:widget_token].is_a?(String)
      secure = options.delete(:secure)
      version = options.delete(:version) || '1'
      src = "#{secure ? 'https' : 'http'}://www.refreshingmenus.com/api/v#{version}/widget.js?#{options.to_param}"
      return "<script id='#{options[:dom_id]}' src='#{src}'></script>"
    end

  end
end
