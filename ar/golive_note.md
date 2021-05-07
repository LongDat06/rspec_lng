# GO LIVE Preparation

Contents:

* [Infrastructure](#infrastructure)
  * [EC2](#ec2)
  * [RDS](#rds)
  * [MongoDB](#mongodb)
  * [S3](#s3)
  * [Redis](#redis)
* [Deployement Noted](#deployment-noted)
  * [CSM Config](#csm-config)
  * [Enviroment Variables](#eviroment-variables)
  * [Running Migration](#running-migration)
* [Related](#related)
  * [Related requirements](#related-requirements)
* [Notes](#notes)


## Infrastructure


### EC2

### RDS

### MongoDB

### S3

### Redis


## Deployement Noted


### CSM Config

* Create LNG-DGI company by csm management
* Create LNG user which belongs_to that LNG company
* After create LNG-DGI set SIMULATION_COMPANY_IDS= on CSM by id of LNG-DGI
* ApiTokenService.instance.create_token_for_user(user_email: 'email@dgi.com', token: example_token)
* Create AIS Setting for that LNG company the setting will be below:
** Company selecte LNG-DGI
** Max IMO requested isn't required so can set 999999999


### Enviroment Variables on EC2 LNG BACK-END

<!-- # AIS Domain -->
LNG_CSM_OPEN_API_TOKEN=
LNG_CSM_OPEN_API_URI=
ALLOW_CORS_DOMAIN=

<!-- # S3 -->
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_REGION=
AWS_S3_BUCKET=
SIDEKIQ_USERNAME=
SIDEKIQ_PASSWORD=
LNG_REDIS_SIDEKIQ_URL=
JWT_ACCESS_PRIVATE_KEY=
JWT_REFRESH_PRIVATE_KEY=

<!-- # SHIP DC -->
LNG_SHIP_DC_API_URI=https://api.shipdatacenter.com
LNG_SHIP_DC_API_KEY=
LNG_SHIP_DC_SP_APP_KEY=
LNG_SHIP_DC_SU_DATA_KEY=

ECDIS_GMAIL_USERNAME=
ECDIS_GMAIL_PASSWORD=
SHARED_TMP=


### Running Migration

* Analytic::SimServices::Importing::SimChannel.new.()
* bundle exec rake mongoid_search:index


## Related

### Related requirements

* Setup capistrano for production after infrastructe have setup

## Notes

Any notes here.
