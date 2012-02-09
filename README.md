# OmniAuth Geni

Geni OAuth2 Strategy for OmniAuth 1.0.

Supports the OAuth 2.0 server-side. Read the Geni docs for more details: http://www.geni.com/platform/developer/help

## Installing

Add to your `Gemfile`:

```ruby
gem 'omniauth-geni'
```

Then `bundle install`.

## Usage

`OmniAuth::Strategies::Geni` is simply a Rack middleware. Read the OmniAuth 1.0 docs for detailed instructions: https://github.com/intridea/omniauth.

Here's a quick example, adding the middleware to a Rails app in `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :geni, ENV['GENI_KEY'], ENV['GENI_SECRET']
end
```

## Configuring

You can configure several options, which you pass in to the `provider` method via a `Hash`:

* `scope`: A comma-separated list of permissions you want to request from the user. See the Geni docs for a full list of available permissions. Default: `email`.
* `display`: The display context to show the authentication page. Options are: `web`, `desktop` and `mobile`. Default: `web`.

For example, to request `email` permission and display the authorization page in a mobile app:
 
```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :geni, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], :scope => 'email', :display => 'mobile'
end
```

*NB.* If you want to set the `display` format on a per-request basis, you can just pass it to the OmniAuth request phase URL, for example: `/auth/geni?display=popup`.

## Authentication Hash

Here's an example *Authentication Hash* available in `request.env['omniauth.auth']`:

```ruby
{
  :provider => 'geni',
  :uid => '123',
  :info => {
    :first_name => 'Alex',
    :last_name => 'Thompson',
    :email => 'alex@sample.com',
    :name => 'Alex Thompson'
  },
  :credentials => {
    :token => 'ABCDEF...', # OAuth 2.0 access_token, which you may wish to store
    :expires_at => 1321747205, # when the access token expires (if it expires)
    :expires => true # if you request `offline_access` this will be false
  },
  :extra => {
    :profile => {
      :id => '1234567',
      :name => 'Alex Thompson',
      :first_name => 'Alex',
      :last_name => 'Thompson'
    }
  }
}
```

The precise information available may depend on the permissions which you request.
