(import [tweets :as t])

(require hy.contrib.anaphoric)


(def adjectives
  ["drunk" "stoned" "tipsy" "befuddled" "buzzed" "crocked"
           "flushed" "high" "inebriated" "laced" "plastered"
           "wasted" "intoxicated"])

(def phrases
  ["you're" "you are" "you"])

(def flags
  (list (apply (fn []
    (for [adj adjectives]
      (for [phr phrases]
        (yield (+ phr " " adj))))))))

(defn print_drunk_stream []
  "Print the stream of human-labeled drunk tweets"
  (let [[it (drunk_tweets)]]
    (for [tweet it]
      (t.print_tweet tweet))))

(defn drunk_tweets []
  "Get an iterator of human-labeled drunk tweets"
  (let [[q (.join "," flags)]
        [fs (t.text_filtered_stream q)]
        [dts (map get_drunk_tweet fs)]]
    (ap-filter (not (nil? it)) dts)))

(defn has_valid_flag? [tweet]
  "Return True if the txt contains a valid drunk tweet response"
  (let [[txt (t.tweet_text tweet)]
        [pred (fn [resp] (in txt resp))]]
    (some pred flags)))

(defn get_drunk_tweet [response]
  "Get the original tweet that prompted the drunk response tweet"
  (let [[id (t.tweet_reply_to response)]]
    (if id
      (t.get_tweet id))))

(defmain [&rest args]
  (print_drunk_stream))
