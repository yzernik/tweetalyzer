(import [datetime :as dt]
        [tweetalyzer.classify :as c]
        [tweetalyzer.tweets :as t])

(def interval
  (let [[numdays (/ 1 1000)]]
    (apply dt.timedelta [] {"days" numdays})))

(defn listen []
  "Listen to the tweet stream and check for drunk tweets periodically"
  (let [[t (now)]]
    (for [tweet (candidate-tweets)]
      (if (ready-for-request? t (now))
        (do (setv t (now))
            (tweetalyze tweet))))))

(defn candidate-tweets []
  "Get a sample stream of tweets to check"
  (->> (t.sample-stream)
       (filter t.has-text?)
       (filter t.in-english?)))

(defn now []
  "Datetime now"
  (.now dt.datetime))

(defn ready-for-request? [prev cur]
  "Check if enough time passed (for rate limiting)"
  (let [[diff (- cur prev)]]
    (> diff interval)))

(defn tweetalyze [tweet]
  "Predict if a tweet is a tweet is a drunk tweet, and if so, reply."
  (if (is-drunk? tweet)
    (respond tweet)))

(defn is-drunk? [tweet]
  "Return True if the tweet is classified as drunk"
  (let [[txt (t.tweet_text tweet)]
        [prediction (c.predict txt)]]
    (= "drunk" prediction)))

(defn respond [tweet]
  "Respond to a drunken tweet"
  (t.send-tweet-reply tweet "You appear to be drunk"))

(defmain [&rest args]
  (listen))
