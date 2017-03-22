#!/bin/bash
set -x
set -e

export PATH=/anaconda/bin:$PATH

conda-build-all recipes \
		--inspect-channels epruesse \
		--upload-channels epruesse \
		--no-inspect-conda-bld-directory


#anaconda -t $CONDA_UPLOAD_TOKEN upload -u epruesse 
