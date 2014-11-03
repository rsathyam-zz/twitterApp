### Basic Twitter client

This is a small Twitter client that shows the last 20 posts for a user (refreshable). It allows a 
user to signout/in, compose new message, retweet, favorite and respond to messages. It also has icons
that change color (from light gray to dark) if a message is retweeted or favorited. Finally, it allows you
to unfavorite correctly (undoing a retweet doesn't work correctly, it just updates the number correctly). The API is
damn confusing, and there is no straightforward way to undo a retweet IMO.


### Time spent
11 hours spent in total

### Completed tasks

 * [x] Required: User can sign in using OAuth login flow 
 * [x] Required: User can view last 20 tweets from their home timeline
 * [x] Required: The current signed in user will be persisted across restarts
 * [x] Required: In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp. In other words, design the custom cell with the proper Auto Layout settings. You will also need to augment the model classes.
 * [x] Required: User can pull to refresh
 * [x] Required: User can compose a new tweet by tapping on a compose button.
 * [x] Required: User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
 * [x] Optional: When composing, you should have a countdown in the upper right for the tweet limit.
 * [x] Optional:  After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
 * [x] Optional: Retweeting and favoriting should increment the retweet and favorite count.
 * [x] Optional: (PARTIALLY DONE - UNDOING A RETWEET DOES NOT WORK) User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
 * [x] Optional: Replies should be prefixed with the username and the reply_id should be set when posting the tweet,

### Walkthrough
![Video Walkthrough](assignment3.gif)

Credits
---------
* [Twitter API](http://api.twitter.com)
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
