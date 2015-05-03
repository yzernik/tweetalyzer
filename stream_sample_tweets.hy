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
  (apply t_stream.TwitterStream
         []
         {"auth" auth}))


(defn make_sample_tweet_iter [stream]
  (.sample stream.statuses))


(defn make_drunk_response_tweet_iter [stream]
  (let [[q "drunk"]
        [kwargs {"track" q}]]
    (apply (. stream.statuses filter) [] kwargs)))


(defn start_stream []
  (let [[auth (make_auth)]
        [stream (make_stream auth)]
        [tweet_iter (make_drunk_response_tweet_iter stream)]]
    (for [tweet tweet_iter]
      (print (tweet_text tweet)))
    0))


(defn tweet_text [tweet]
  (if (in "text" tweet)
    (get tweet "text")
    nil))


(defn tweetalyze []
  (do
   (print "hy")
   (start_stream)
   (print "by")))


(defmain [&rest args]
  (tweetalyze))
