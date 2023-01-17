#!/bin/bash

cp config build_tools/config || true
docker run -it -v ${PWD}:/r7/R7DesktopEditors:z -w /r7/R7DesktopEditors/build_tools r7de-build1804 python3 make.py

