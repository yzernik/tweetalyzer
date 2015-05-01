(import [tweepy.streaming [StreamListener]])
(import [tweepy [OAuthHandler Stream]])

(import config)


(defclass StdOutListener [StreamListener]
  [[on_data (fn [self data]
              (print data)
              True)]
   [on_error (fn [self data]
              (print data))]])

(def auth
  (let [[ck config.consumer_key]
        [cs config.consumer_secret]
        [at config.access_token]
        [ats config.access_token_secret]]
    (doto (OAuthHandler ck cs)
          (.set_access_token at ats))))

(let [[l (StdOutListener)]
      [stream (Stream auth l)]]
  (apply (. stream sample)))
