Analyze your tweets with neo4j!

Usage:
======

 * Check out github repo
 * Run `bundle`
 * Run one of the following commands (the first will continuously stream until you cancel with `ctrl-c`):

```ruby
    neo4apis twitter filter QUERY --import-retweets --import-hashtags --import-user-mentions

    neo4apis twitter search QUERY NUMBER_OF_TWEETS --import-retweets --import-hashtags --import-user-mentions
```

 * Start the rails app with `rails s`
 * Visit the app

What you get:
=============

 * Pretty metrics such as:
   * Top Tweeters
   * Top Retweeters
   * Original Tweets (that is, excluding retweets) Over Time
   * Most Favorited Tweets
   * Most Retweeded Tweets
 * Ability to browse through users, tweets, and hashtags
 * Graph visualization of hashtags
 * Embedded tweets, where possible

How to help:
===========

Feedback!  What metrics would you like to see?  What metrics do you think would be useful for everybody?

Bug reports!  Open a github issue!

Pull requests!  I'll buy you a drink if I ever meet you!


