(import [metamind.api :as mm]
        [tweetalyzer.config :as conf])


(mm.set_api_key conf.metamind_api_key)

(def model
  (let [[id conf.metamind_classifier_id]]
    (apply mm.ClassificationModel [] {"id" id})))

(defn predict [txt]
  "Get the prediction label for given text"
  (let [[resp (apply (. model predict) [txt] {"input_type" "text"})]]
    (print "resp: " resp)
    (get (first resp) "label")))
