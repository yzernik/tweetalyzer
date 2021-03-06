(import [twitter :as t]
        [twitter.api :as t-api]
        [twitter.stream :as t-stream]
        [twitter.oauth :as t-oauth]
        [twitter.util :as t-util]
        [tweetalyzer.config :as conf])

(def auth
  (let [[ck conf.consumer-key]
        [cs conf.consumer-secret]
        [at conf.access-token]
        [ats conf.access-token-secret]]
    (t-oauth.OAuth at ats ck cs)))

(def rest-client
  (apply t.Twitter [] {"auth" auth}))

(def stream-client
  (apply t-stream.TwitterStream [] {"auth" auth}))

(defn get-tweet [id]
  "Get a tweet by id"
  (try
   (apply (. rest-client.statuses show) [] {"id" id})
   (catch [e t-api.TwitterHTTPError] nil)))

(defn send-tweet-reply [tweet msg]
  "Send a reply to a tweet with a message"
  (let [[id (tweet-attr tweet "id")]
        [user (tweeter-screen-name tweet)]
        [txt (+ "@" user " " msg)]]
    (try
     (apply (. rest-client.statuses update) [] {"status" txt "in_reply_to_status_id" id})
     (catch [e t-api.TwitterHTTPError] nil))))

(defn sample-stream []
  "Make an iterator of sample tweets"
  (.sample stream-client.statuses))

(defn text-filtered-stream [q]
  "Make an iterator of text filtered tweets"
  (apply (. stream-client.statuses filter) [] {"track" q}))

(defn tweet-attr [tweet attr]
  "Get an attribute of a tweet if it exists, else nil"
  (if (in attr tweet) (get tweet attr) nil))

(defn tweet-text [tweet]
  "Get the text attribute of a tweet"
  (let [[raw-txt (tweet-attr tweet "text")]]
    (if raw-txt
      (.replace raw-txt "\n" ""))))

(defn has-text? [tweet]
  "Returns True if the tweet has text"
  (if (tweet-text tweet) True))

(defn in-english? [tweet]
  "Return True if the tweet is in English"
  (= "en" (tweet-attr tweet "lang")))

(defn tweeter-screen-name [tweet]
  "Get the tweeter's screen name"
  (let [[user (tweet-attr tweet "user")]]
    (get user "screen_name")))

(defn tweet-reply-to [tweet]
  "Get the in_reply_to_status_id_str attribute of a tweet"
  (tweet-attr tweet "in_reply_to_status_id_str"))
