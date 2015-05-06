(import [twitter :as t]
        [twitter.api :as t_api]
        [twitter.stream :as t_stream]
        [twitter.oauth :as t_oauth]
        [twitter.util :as t_util]
        [config :as conf])

(def auth
  (let [[ck conf.consumer_key]
        [cs conf.consumer_secret]
        [at conf.access_token]
        [ats conf.access_token_secret]]
    (t_oauth.OAuth at ats ck cs)))

(def rest_client
  (apply t.Twitter [] {"auth" auth}))

(def stream_client
  (apply t_stream.TwitterStream [] {"auth" auth}))

(defn get_tweet [id]
  "Get a tweet by id"
  (try
   (apply (. rest_client.statuses show) [] {"id" id})
   (catch [e t_api.TwitterHTTPError] nil)))

(defn sample_stream []
  "Make an iterator of sample tweets"
  (.sample stream_client.statuses))

(defn text_filtered_stream [q]
  "Make an iterator of text filtered tweets"
  (apply (. stream_client.statuses filter) [] {"track" q}))

(defn tweet_attr [tweet attr]
  "Get an attribute of a tweet if it exists, else nil"
  (if (in attr tweet)
    (get tweet attr)
    nil))

(defn tweet_text [tweet]
  "Get the text attribute of a tweet"
  (tweet_attr tweet "text"))

(defn has_text? [tweet]
  "Returns True if the tweet has text"
  (not (nil? (tweet_text tweet))))

(defn tweet_reply_to [tweet]
  "Get the in_reply_to_status_id_str attribute of a tweet"
  (tweet_attr tweet "in_reply_to_status_id_str"))

(defn print_tweet [tweet]
  "Print the text of a tweet in a single line"
  (let [[id (tweet_attr tweet "id")]
        [txt (tweet_text tweet)]]
    (print id (.replace txt "\n" ""))))
