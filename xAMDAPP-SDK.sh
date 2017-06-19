#!/bin/bash
echo "DIRTY HACK TO FORCE THE SDK TO WORK, MEANT FOR CRUX 3.3"
cp /opt/AMDAPPSDK-3.0/include/* /usr/include/
cp /opt/AMDAPPSDK-3.0/lib/x86_64/sdk/* /lib64/
ldconfig
