#!/bin/bash
set -x
set -e

conda-build-all recipes

anaconda -t $CONDA_UPLOAD_TOKEN upload -u epruesse 
