Weather App
=======

Weather (a.k.a. "Hail Yeah!") is a tiny weather app designed to fetch and display weather via street address.
Weather info is cached for a maximum of 30 minutes

## Overview of Forecast lifecycle
After loading the app and inputting an address or zip code, it will return a forecast for the location specified.

**Parsing**
First, the `ForecastController` will parse the parameters from `ForecastController#create`, understanding if the input is a 5-digit zip code (assumption) or an address to look up remotely. The forecast is cached with address and zip code information and is retrievable by both. If a cached record is over 30 minutes old, it is considered invalid, and an updated forecast will be requested.

**Looking up a forecast**
If the input is deemed new and valid (no symbols are allowed), the controller will `Forecast#request_forecast_async`. The incomplete `Forecast` record is immediately rendered; the forecast content will be remotely loaded later.

Note: an incomplete part of the functionality is getting `turbo_stream` to work for the record. As a very temporary solution, the page reloads once a second until the forecast is retrieved.


**`Forecast#request_forecast_async`**
Requesting a forecast is split amongst several Ruby classes.

The forecast request flow is:
```
Forecast#request_forecast_async
-> ForecastRequesterJob.perform_now(self.id)
-> Forecast#request_forecast!
-> Forecast::Requester.new(self.address)
-> Network request
-> Persist forecast information in Forecast.data
```

In summary, a worker, `ForecastRequesterJob`, is scheduled to run immediately. That job calls the `Forecast#request_forecast!` method. Inside that method are two jobs, request the information through `Forecast::Requester`, and save the response if it is valid.

**Rendering the Forecast**
As mentioned, the forecast data for an address or zip code is requested and saved asynchronously. Once rendered, the `data` attribute of Forecast is loaded into the `ForecastDataSerializer`, making specific field retrieval simpler and somewhat more reliable.

If the Forecast record is was already persisted and simply recalled, the UI will show a "Cached – Next refresh in X minutes" badge. In addition, when requesting a record that already existed, a flash message is added to indicate cache use.


**Performance considerations**
This approach, while functional, would likely run into performance bottlenecks if open to the internet and used heavily.

There's an index on zip code for faster lookup, but that likely could be converted into an integer format for faster comparisons. It wasn't done as part of this exercise to accommodate postal codes outside the USA, which might follow different conventions.

While this app uses Postgres for storage, Redis was added to, *eventually*, compare lookup timing. It might be more performant to query Redis for only the information needed in the view, namely temperature, conditions, precipitation, humidity, and wind (the values shown in `forecasts/show.html.erb`).

In addition, two APIs were used, WeatherAPI and HERE to complete the functionality. WeatherAPI does not provide zip code, only `name` (usually city), `region` (e.g. California), and `country`. HERE provides significant geocode information, but we only require the `postalCode` field. Consolidating down to one API request would be a big improvement to performance and simplicity.

**Testing**
While testing is *clearly* incomplete, many tests have been stubbed and skipped to help explain the expected behavior of the various classes in use.

**System Details**
* Ruby version
`3.3.4`

* System dependencies: 
`Ruby 3.3.4, Rails 7.2.1, Postgres, Redis, Sidekiq`

* Database creation & initialization: `bin/setup`

* Run the Minitest test suite with: `rails test`

* Deployment is not built!
  * Some next steps are:
    - configure db for production, name/secret
    - use docker
    - set up CI
    - pick a PaaS or hosting provider
    - set up monitoring
    - consider nginx, cargo, or thruster for proxy and rate-limiting

**TODO**
There is a lot left to do to make this project viable. Here are the ones I'm immediately aware of:
- rename form param: address -> query
- Fix turbo stream refresh (not refreshing)
- Single API usage
  - On initial investigation, I was unable to find an API that could provide both forecast lookup by address AND return location information that included postal codes
  - TODO is to find a single API to ensure forecast information, address, and zipcode all match
    - The use of two API **will** result in data inconsistency, invalidating the use of the cache
- Tests aren't complete:
  - Add tests for forecast_serializer, forecast_requester, zipcode_requester, zipcode_serializer
  - Improve coverage for controllers
  - Add system tests
