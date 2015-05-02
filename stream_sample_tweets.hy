(import [twitter.stream :as t_stream]
        [twitter.oauth :as t_oauth]
        [twitter.util :as t_util]
        [config :as conf])


(defn make_auth []
  (let [[ck conf.consumer_key]
        [cs conf.consumer_secret]
        [at conf.access_token]
        [ats conf.access_token_secret]]
    (t_oauth.OAuth at ats ck cs)))


(defn make_stream [auth]
  (t_stream.TwitterStream
   "stream.twitter.com" True auth))


(defn start_stream []
  (let [[auth (make_auth)]
        [stream (make_stream auth)]
        [tweet_iter (.sample stream.statuses)]]
    (for [tweet tweet_iter]
      (print tweet))
    0))


(defn tweetalyze []
  (do
   (print "hy")
   (start_stream)
   (print "by")))


(defmain [&rest args]
  (tweetalyze))
