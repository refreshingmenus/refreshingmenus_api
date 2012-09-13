# RefreshingmenusApi

Ruby API to use the Refreshing Menus REST API.

## Installation

Add this line to your application's Gemfile:

    gem 'refreshingmenus_api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install refreshingmenus_api

## Usage

    api = RefreshingmenusApi::Client.new(:auth_token => 'your_auth_token_here')
    result = api.places(:q => "o'pazzo") # Returns Array or results
    result.first[:name] # => "O'Pazzo Pizzeria"
    result.first[:id] # => "194ebdcc-fcd9-11e1-b4ac-5254006b3bb5"
    result.first[:menus].first[:title] # => "Pizzeria Kaart" 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
