


```
import tensorflow as tf
saved_model_dir = '/home/opc/content/traffic_police_inference_graph/saved_model'
converter = tf.lite.TFLiteConverter.from_saved_model(saved_model_dir)
tflite_model = converter.convert()
open("detect.tflite", "wb").write(tflite_model)
```
