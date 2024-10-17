Weather App
=======

Weather (a.k.a. "Hail Yeah!") is a tiny weather app designed to fetch and display weather via street address.
Weather info is cached for a maximum of 30 minutes

## Overview of Forecast lifecycle
After loadinag the app, an inputing an address or zipcode 

**System Details**
* Ruby version
`3.3.4`

* System dependencies: 
`Ruby 3.3.4, Rails 7.2.1, Postgres, Redis, Sidekiq`

* Database creation & initialization: `bin/setup`

* Run the Minitest test suite with: `rails test`

* Deployment instructions
-under construction-

**TODO**
- adjust adjust lookup by zip, if not found then generate new one by address
- Fix turbo stream refresh (not refreshing)
- Tests aren't complete: Add tests for forecast_serializer, forecast_requester
- Deployment
  - configure db for production, name/secret
  - use docker
  - set up CI
  - pick a PaaS or hosting provider
  - set up monitoring
  - consider nginx, cargo, or thruster for proxy and rate-limiting
