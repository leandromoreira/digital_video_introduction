#!/bin/bash
# Run Jupyter Notebook (Python 3.5.2, scipy 0.17.1)
docker run --rm -p 8888:8888 -v $(pwd):/home/jovyan/work  jupyter/scipy-notebook:387f29b6ca83
