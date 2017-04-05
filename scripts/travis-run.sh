#!/bin/bash
set -x
set -e

export PATH=/anaconda/bin:$PATH

# patch resolve.py to work around a bug
#patch /anaconda/lib/python3.6/site-packages/conda/resolve.py <scripts/resolve.patch || true

conda-build-all recipes \
		--inspect-channels epruesse \
		--upload-channels epruesse \
		--no-inspect-conda-bld-directory \
		--matrix-condition "python >=2.7,<3|>=3.4,<3.5|>=3.5,<3.6"


#anaconda -t $CONDA_UPLOAD_TOKEN upload -u epruesse 
