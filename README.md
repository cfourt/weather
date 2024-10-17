# Weather App
Weather ((aka. Hail Yeah!) is a tiny weather app designed to fetch and display weather via street address.
Weather info is cached for a maximum of 30 minutes

**A quick overview of the system**
* Ruby version
`3.3.4`

* System dependencies: 
`Ruby 3.3.4, Rails 7.2.1, Postgres, Redis`

* Database creation & initialization: `bin/setup`

* Run the Minitest test suite with: `rails test` 

* Services (job queues, cache servers, search engines, etc.)
  - Redis and sidekiq 

* Deployment instructions
None yet!
    - Next steps:
      - adjust hashing function
      - configure db for production, name/secret
      - use docker
      - set up CI
      - pick a PaaS or hosting provider
      - set up monitoring
      - consider nginx, cargo, or thruster for proxy and rate-limiting

TODO
- partial index on db 
- adjust hashing function to be based on name+region+country
- show record should double check valid
- The model always returns something
