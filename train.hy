(import [tweets :as t])

(require hy.contrib.anaphoric)


(def adjectives
  ["drunk" "stoned" "tipsy" "befuddled" "buzzed" "crocked"
           "flushed" "high" "inebriated" "laced" "plastered"
           "wasted" "intoxicated"])

(def prefixes
  ["you're" "you are" "you"])

(def phrases
  (list (apply (fn []
    (for [adj adjectives]
      (for [pre prefixes]
        (yield (+ pre " " adj))))))))

(defn print-labeled-tweets [label stream n]
  "Print some number of labeled tweets from a stream"
  (let [[it (take n (stream))]]
    (for [tweet it]
      (print (labeled-row label tweet)))))

(defn labeled-row [label tweet]
  "Create a labeled row of TSV data for training"
  (let [[data (-> tweet
                  (t.tweet_text)
                  (.replace "\n" ""))]]
    (.join "\t" [label data])))

(defn drunk-tweets []
  "Get an iterator of human-labeled drunk tweets"
  (let [[q (.join "," phrases)]
        [fs (t.text-filtered-stream q)]]
    (->> fs
         (filter has-drunk-response-phrase?)
         (map get-drunk-tweet)
         (filter identity))))

(defn normal-tweets []
  "Get an iterator of normal tweets"
  (->> (t.sample-stream)
       (filter t.has-text?)))

(defn has-drunk-response-phrase? [tweet]
  "Return True if the text contains a valid drunk tweet response"
  (let [[txt (t.tweet-text tweet)]]
    (if txt
      (some (fn [phrase] (in (.lower phrase) (.lower txt))) phrases))))

(defn get-drunk-tweet [response]
  "Get the original tweet that prompted the drunk response tweet"
  (ap-if (t.tweet-reply-to response)
         (t.get-tweet it)))

(defmain [&rest args]
  (print-labeled-tweets "sober" normal-tweets 5)
  (print-labeled-tweets "drunk" drunk-tweets 5))
