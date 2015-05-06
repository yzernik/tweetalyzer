(import [tweets :as t]
        [config :as conf])

(require hy.contrib.anaphoric)


(defn start_drunk_stream []
  (let [[it (drunk_tweets)]]
    (for [tweet it]
      (print tweet)
      (print "*****************************"))
    0))

(defn drunk_tweets []
  "Get an iterator of human-labeled drunk tweets"
  (let [[q "drunk"]
        [fs (t.text_filtered_stream q)]
        [dts (map get_drunk_tweet fs)]]
    (ap-filter (not (nil? it)) dts)))

(defn get_drunk_tweet [response]
  "Get the original tweet that prompted the drunk response tweet"
  (let [[id (t.tweet_reply_to response)]]
    (print (, "id" id))
    (if (not (nil? id))
      (t.get_tweet id)
      nil)))

(defn tweetalyze []
  (do
   (start_drunk_stream)))

(defmain [&rest args]
  (tweetalyze))
