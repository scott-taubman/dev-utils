#!/bin/bash

PYPATH=`python -c 'import site; print(site.getsitepackages()[0])'`
rm -f ${PYPATH}/sitecustomize.py

echo "----------------------------------------------------"
echo "Setting up sitecustomize.py for local library use."
echo "PYPATH=${PYPATH}"

cp /opt/scripts/sitecustomize.py ${PYPATH}/sitecustomize.py

echo "Done!"
echo "----------------------------------------------------"
