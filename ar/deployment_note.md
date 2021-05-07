# Deployment note: 
##  the format, write by Dev when creating PR: 
### Parent-ticket-id on JIRA 
  * Deployment steps: 
  * config env 
  * install dependency package 
  * migration data 
  * integrate  third party
  * ... 

### GNG-1733
  Adding these env variables  on Staging, Production
  * SIDEKIQ_USERNAME
  * SIDEKIQ_PASSWORD
  * LNG_REDIS_SIDEKIQ_URL

### GNG-1463
  * export JWT_ACCESS_PRIVATE_KEY=
  * export JWT_REFRESH_PRIVATE_KEY=

### GNG-1471
  * Analytic::MigrationServices::Mar2021::Gng1471.new.()

### GNG-1848
  Adding these env variables on Staging, Production
  * ECDIS_GMAIL_USERNAME
  * ECDIS_GMAIL_PASSWORD
  * SHARED_TMP

### GNG-1881
  * LNG_SHIP_DC_API_URI=
  * LNG_SHIP_DC_API_KEY=
  * LNG_SHIP_DC_SP_APP_KEY=
  * LNG_SHIP_DC_SU_DATA_KEY=
  * Analytic::SimServices::Importing::SimChannel.new.()
  * rake mongoid_search:index

### Create new index
  * bundle exec rake db:mongoid:create_indexes
