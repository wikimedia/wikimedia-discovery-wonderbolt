Traffic from external search engines - summary
=======

A key metric in understanding the role external search engines play in Wikipedia's readership and content discovery processes is a very direct one - how many pageviews we get from them. This can be discovered very simply by looking at our request logs.

This dashboard simply looks at, very broadly, where our requests are coming from - search engines or something else? It is split up into
"all", "desktop" and "mobile web" platforms - but not apps, since the apps do not log referers.

**Internal** is traffic referred by Wikimedia sites, specifically: mediawiki.org, wikibooks.org, wikidata.org, wikinews.org, wikimedia.org, wikimediafoundation.org, wikipedia.org, wikiquote.org, wikisource.org, wikiversity.org, wikivoyage.org, and wiktionary.org (See [Webrequest source](https://git.wikimedia.org/blob/analytics%2Frefinery%2Fsource.git/master/refinery-core%2Fsrc%2Fmain%2Fjava%2Forg%2Fwikimedia%2Fanalytics%2Frefinery%2Fcore%2FWebrequest.java#L203) for more information.)

Outages and notes
------
- **A**: We switched to a finalized version of the UDF that extracts internal traffic (see [T130083](https://phabricator.wikimedia.org/T130083))
- **B**: On 25 August 2016 we patched the UDF to also look for [Duck Duck Go](https://duckduckgo.com) when it processes referer data. That referreral data was deleted and backfilled from 26 June 2016. See [T143287](https://phabricator.wikimedia.org/T143287) for more details.

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Deb](mailto:deb@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small; color: gray;">
  <strong>Link to this dashboard:</strong>
  <a href="http://discovery.wmflabs.org/external/#traffic_summary">
    http://discovery.wmflabs.org/external/#traffic_summary
  </a>
</p>
