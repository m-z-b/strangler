# Strangler

Strangler provides a simple throttling mechanism to ensure that there is a minimum delay between calls to a code block. This can be used to ensure that calls to a remote API do not exceed a specific rate.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'strangler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install strangler

## Usage

Typical usage is as follows:

    strangler = Strangler.new( 1.5 )
    ...
    strangler.throttle! do
        ...
        #make external API call here
        ...
    end

This ensures (by sleeping the current thread) that a call to the external API does not occur until at least 1.5 seconds after the previous call completed.

Note that if you are writing a Rails app with multiple processes (e.g. by using Passenger), you will need to somehow ensure that all rate limited API calls are made by the same process. 

The specifications of the rate limits for APIs are often ambiguous: does a rate limit of 1 call per second allow a call that takes 2 seconds to overlap with another call after the first second? Strangler takes the most conservative interpretation possible - calls cannot overlap and and the delay argument given to the Strangler constructor is the minimum time between the start of one block execution and the end of the previous block execution.

## Design Philosophy

This gem is designed to handle the simple use case of calling an API (possibly from multiple threads) which has a rate limit. 

If you need a more sophisticated strategy (e.g. to perform useful work rather than sleeping, or to avoid potential thread starvation by the thread scheduler) then you should probably be using a different gem.

Sorry about the gem name: the good names were already taken.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/m-z-b/strangler.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
