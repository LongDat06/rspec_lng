# Database

Contents:

* [Summary](#summary)
  * [Issue](#issue)
  * [Decision](#decision)
  * [Status](#status)
* [Details](#details)
  * [Assumptions](#assumptions)
  * [Positions](#positions)
  * [Argument](#argument)
  * [Implications](#implications)
* [Related](#related)
  * [Related requirements](#related-requirements)
* [Notes](#notes)


## Summary


### Issue

We need to choose a database for our software. We have two major needs: a limitation of Postgres, and a database suitable for data requirement.


### Decision

We are choosing Postgres for data which should be onsistency and persisted the data like user management and vessel.

We are choosing MongoDB for data which is analyzed and change frequently like SIM & SPAS.


### Status

Decided internaly


## Details


### Assumptions

The data requirement are higher-than-typical:

  * Higher-than-typical goals for dynamic, flexible, etc.


### Positions

We considered these database:

  * Cassandra

  * MariaDB

  * MongoDB

  * Postgres


### Argument

We believe that our core decision is driven by two cross-cutting concerns:

  * For data consistency, we would choose Postgres.

  * For flexible and dynamic schema, we choose MongoDB.

  * For fastest query speed and powerful aggregation results, we would choose MongoDB.


### Implications

Back-end developers will need to learn MongoDB. This is likely a moderate learning curve if the developer's primary experience is using NoSQL.


## Related

### Related requirements

Our data requirement very complex and dynamic of the data.


## Notes

Any notes here.
