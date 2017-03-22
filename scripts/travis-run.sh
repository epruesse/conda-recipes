#!/bin/bash
set -x
set -e

export PATH=/anaconda/bin:$PATH

# patch resolve.py to work around a bug
patch /anaconda/lib/python3.6/site-packages/conda/resolve.py <scripts/resolve.patch

conda-build-all recipes \
		--inspect-channels epruesse \
		--upload-channels epruesse \
		--no-inspect-conda-bld-directory


#anaconda -t $CONDA_UPLOAD_TOKEN upload -u epruesse 
