(import [datetime :as dt]
        [classify :as c]
        [tweets :as t])

(def interval
  (let [[numdays (/ 1 1000)]]
    (apply dt.timedelta [] {"days" numdays})))

(defn listen []
  "Listen to the tweet stream and check for drunk tweets periodically"
  (let [[last (now)]]
    (for [tweet (tweets-with-text)]
      (if (ready-for-request? last (now))
        (do (setv last (now))
            (tweetalyze tweet))))))

(defn tweets-with-text []
  "Get a sample stream of tweets with text"
  (filter t.has-text? (t.sample-stream)))

(defn now []
  "Datetime now"
  (.now dt.datetime))

(defn ready-for-request? [last t]
  "Check if enough time passed (for rate limiting)"
  (let [[diff (- t last)]]
    (> diff interval)))

(defn tweetalyze [tweet]
  "Predict if a tweet is a tweet is a drunk tweet, and if so, reply."
  (do (print (t.tweet-text tweet))
      (if (is-drunk? tweet)
        (do (print "******* is drunk!")
            (respond tweet)))))

(defn is-drunk? [tweet]
  "Return true if the tweet is classified as drunk"
  (let [[txt (t.tweet_text tweet)]
        [prediction (c.predict txt)]]
    (= "drunk" prediction)))

(defn respond [tweet]
  "Respond to a drunken tweet"
  (t.send-tweet-reply tweet "You appear to be drunk"))

(defmain [&rest args]
  (listen))
