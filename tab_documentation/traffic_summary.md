Traffic from external search engines - summary
=======

A key metric in understanding the role external search engines play in Wikipedia's readership and content discovery processes is a very direct one - how many pageviews we get from them. This can be discovered very simply by looking at our request logs.

This dashboard simply looks at, very broadly, where our requests are coming from - search engines or something else? It is split up into
"all", "desktop" and "mobile web" platforms - but not apps, since the apps do not log referers.

General trends
------

Outages and notes
------
- **A**: We switched to a finalized version of the UDF that extracts internal traffic (see [T130083](https://phabricator.wikimedia.org/T130083))

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Dan](mailto:dgarry@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small; color: gray;">
  <strong>Link to this dashboard:</strong>
  <a href="http://discovery.wmflabs.org/external/#traffic_summary">
    http://discovery.wmflabs.org/external/#traffic_summary
  </a>
</p>
