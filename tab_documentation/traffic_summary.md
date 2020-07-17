Traffic from external search engines - summary
=======

A key metric in understanding the role external search engines play in Wikipedia's (and Wikimedia's) readership and content discovery processes is a very direct one - how many pageviews we get from them. This can be discovered very simply by looking at our request logs.

This dashboard simply looks at, very broadly, where our pageviews (across all Wikimedia projects) are coming from - search engines or something else? It is split up into
"all", "desktop" and "mobile web" platforms - but not apps, since the apps do not log referers.

**Internal** is traffic referred by Wikimedia sites, specifically: mediawiki.org, wikibooks.org, wikidata.org, wikinews.org, wikimedia.org, wikimediafoundation.org, wikipedia.org, wikiquote.org, wikisource.org, wikiversity.org, wikivoyage.org, and wiktionary.org (See [Webrequest source](https://phabricator.wikimedia.org/diffusion/ANRS/browse/master/refinery-core/src/main/java/org/wikimedia/analytics/refinery/core/Webrequest.java) for more information.)

Outages and notes
------
* '__A__': We switched to a finalized version of the UDF that extracts internal traffic (see [T130083](https://phabricator.wikimedia.org/T130083))
* '__B__': on 25 August 2016 we patched the UDF to also look for [Duck Duck Go](https://duckduckgo.com) when it processes referer data. That referreral data was deleted and backfilled from 26 June 2016. See [T143287](https://phabricator.wikimedia.org/T143287) for more details.
- On 22 February 2016, a bug was introduced and some of the internally referred traffic are miscategorized as none. See [T148780](https://phabricator.wikimedia.org/T148780) and [T154722](https://phabricator.wikimedia.org/T154722) for more details.
* '__R__': on 2017-01-01 we started calculating all of Discovery's metrics using a new version of [our data retrieval and processing codebase](https://phabricator.wikimedia.org/diffusion/WDGO/) that we migrated to [Wikimedia Analytics](https://www.mediawiki.org/wiki/Analytics)' [Reportupdater infrastructure](https://wikitech.wikimedia.org/wiki/Analytics/Reportupdater). See [T150915](https://phabricator.wikimedia.org/T150915) for more details.
* '__U__': on 2020-05-01 some of the traffic that would have previously been categorized as "user" began being categorized as "automated" (different than "spider", which referred to web crawlers and self-identified bots). See [wikitech:Analytics/Data Lake/Traffic/BotDetection](https://wikitech.wikimedia.org/wiki/Analytics/Data_Lake/Traffic/BotDetection) for more details.

--------
<hr style="border-color: gray;">
<p style="font-size: small;">
  <strong>Link to this dashboard:</strong> <a href="https://discovery.wmflabs.org/external/#traffic_summary">https://discovery.wmflabs.org/external/#traffic_summary</a>
  | Page is available under <a href="https://creativecommons.org/licenses/by-sa/3.0/" title="Creative Commons Attribution-ShareAlike License">CC-BY-SA 3.0</a>
  | <a href="https://gerrit.wikimedia.org/g/wikimedia/discovery/wonderbolt" title="External Traffic Dashboard source code repository">Code</a> is licensed under <a href="https://gerrit.wikimedia.org/r/plugins/gitiles/wikimedia/discovery/wonderbolt/+/refs/heads/master/LICENSE.md" title="MIT License">MIT</a>
  | Part of <a href="https://discovery.wmflabs.org/">Discovery Dashboards</a>
</p>
