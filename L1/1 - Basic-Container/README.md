# To build and execute the container run.

```bash
docker build --tag bigdata .
docker run -p 8888:8888 -i -t bigdata /bin/bash
```
# To test that the image is working correctly, execute:

```bash
source /opt/venv/bin/activate
cd basic
spark-submit read.py
```

The output should look like:

```bash
+---+-----------+
| id|       name|
+---+-----------+
|  1| Juan Perez|
|  2|Maria Lopez|
+---+-----------+
```