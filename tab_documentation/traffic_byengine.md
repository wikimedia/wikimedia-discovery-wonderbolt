Traffic from external search engines, broken down
=======

A key metric in understanding the role external search engines play in Wikipedia's readership and content discovery processes is a very direct one - how many pageviews we get from them. This can be discovered very simply by looking at our request logs.

This dashboard simply breaks down the [summary data](http://discovery.wmflabs.org/external/#traffic_summary) to investigate how much traffic is coming from each search engine, individually. As you can see, Google dominates, which is why we've included the option of log-scaling
the traffic.

General trends
------

Outages and notes
------
- **A**: On 25 August 2016 we patched the UDF to also look for [Duck Duck Go](https://duckduckgo.com) when it processes referer data. That referreral data was deleted and backfilled from 26 June 2016. See [T143287](https://phabricator.wikimedia.org/T143287) for more details.

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Deb](mailto:deb@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small; color: gray;">
  <strong>Link to this dashboard:</strong>
  <a href="http://discovery.wmflabs.org/external/#traffic_by_engine">
    http://discovery.wmflabs.org/external/#traffic_by_engine
  </a>
</p>
