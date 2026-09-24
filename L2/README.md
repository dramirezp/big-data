# To build and execute the container run.

```bash
docker build --tag bigdatafull .
docker run -p 8888:8888 -i -t -v $(pwd)/../:/bg bigdatafull /bin/bash
```
# Activate python environment, execute:

```bash
source /opt/venv/bin/activat
```


# To run Jupyter notebooks, execute:

```bash
cd /bg
jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root
```

The output looks like:

<p align="center">
  <img src="images/jupyter-run.PNG" alt="TEC" width="800">
</p>

Copy the URL starting with http://127.0.0.1 (in my case, `http://127.0.0.1:8888/tree?token=29d47b2a86f1a67c449c717923e7098cb75845153f94363e`) and open it in your browser.

Open the file `notebook-example/Spark_DataFrames_API.ipynb`

<p align="center">
  <img src="images/notebook.PNG" alt="TEC" width="800">
</p>

Execute all the cells and explore the files and code.

<p align="center">
  <img src="images/run-notebook.PNG" alt="TEC" width="800">
</p>

**IMPORTANT**: This example was obtained from [https://github.com/Pierian-Data/Complete-Python-3-Bootcamp](https://github.com/Pierian-Data/Complete-Python-3-Bootcamp). It is a good resource for becoming familiar with the environment we will be using during the course.