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

(defn print-drunk-stream []
  "Print the stream of human-labeled drunk tweets"
  (let [[it (drunk-tweets)]]
    (for [tweet it]
      (t.print-tweet tweet))))

(defn drunk-tweets []
  "Get an iterator of human-labeled drunk tweets"
  (let [[q (.join "," flags)]
        [fs (t.text-filtered-stream q)]]
    (->> fs
         (filter has-valid-flag?)
         (map get-drunk-tweet)
         (ap-filter (not (nil? it))))))

(defn has-valid-flag? [tweet]
  "Return True if the txt contains a valid drunk tweet response"
  (let [[txt (t.tweet-text tweet)]]
    (if txt
      (some (fn [flag] (in (.lower flag) (.lower txt))) flags))))

(defn get-drunk-tweet [response]
  "Get the original tweet that prompted the drunk response tweet"
  (ap-if (t.tweet-reply-to response)
         (t.get-tweet it)))

(defmain [&rest args]
  (print-drunk-stream))
