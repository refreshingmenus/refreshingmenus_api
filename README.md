# RefreshingmenusApi

Ruby API to use the Refreshing Menus REST API and Javascript Widget.

## Installation

Add this line to your application's Gemfile:

    gem 'refreshingmenus_api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install refreshingmenus_api

## Usage

    api = RefreshingmenusApi::Client.new(:auth_token => 'your_auth_token_here')

### Places

    result = api.places(:q => "o'pazzo") # Returns Array of RefreshingmenusApi::Place objects
    result.first.name # => "O'Pazzo Pizzeria"
    result.first.guid # => "194ebdcc-fcd9-11e1-b4ac-5254006b3bb5"
    result.first.menus_count # => 2
    result.first.menus.first.title # => "Pizzeria Kaart" 

A query to match businesses / venues / places based on a phone number:

    result = api.places(
        :phone => '+31-(0)-10-2065151',
        :country_code => 'NL'
      )
    result.first.normalized_phone # => "31102065151"
    result.first.guid # => "194e9016-fcd9-11e1-b4ac-5254006b3bb5"

This phone number is normalized based on the country_code passed. So '010-2065151' and '+31-(0)-10-2065151' with country_code 'NL' will be normalized to '31102065151'.

Because sometimes multiple places have the same phone number we can do more specific matching:

    result = api.places(
        :q => "#{place.name} #{place.postal_code}", # Matches at least one word.
        :country_code => place.country_code, # Eg. 'NL'
        :lat => place.lat,
        :lng => place.lng,
        :distance => '0.2', # 200 meter
        :phone => place.phone_number # Eg. '010-12341234'. 
      )

### Menus

    result = api.places(:q => "o'pazzo")
    result.first.menus.first # => RefreshingmenusApi::Menu 
    menu1 = result.first.menus.first.fetch!(api) # Pass api client to fetch all Menu info
    menu1.title # => "Pizzeria Kaart"
    menu1.entries.first.title # => "ANTIPASTI"

A Menu is a tree of Entries. An Entry is either a Section (eg. 'Starters') or an Item (eg. 'Hamburger').
Both Sections and Items can have multiple Prices.

## Widget usage

    RefreshingmenusApi::Widget.script_tag(:place_id => 'some_place_id', :widget_token => 'some_token')

This will result in a script tag like:

    <script id='rm-menuwidget' src='http://www.refreshingmenus.com/api/v1/widget.js?dom_id=rm-menuwidget&place_id=some_place_id&widget_token=some_token'></script>"

If you just want the src of the script use:

    RefreshingmenusApi::Widget.script_src(:place_id => 'some_place_id', :widget_token => 'some_token')
    # => "http://www.refreshingmenus.com/api/v1/widget.js?dom_id=rm-menuwidget&place_id=some_place_id&widget_token=some_token"

Other supported options:

* locale - the language of the menu and other texts (disclaimer), defaults to 'nl'.
* style - the CSS style to apply, defaults to 'default'. Use 'none' if you don't want any style to be applied and you include your own.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
