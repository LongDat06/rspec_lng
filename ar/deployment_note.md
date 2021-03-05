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
