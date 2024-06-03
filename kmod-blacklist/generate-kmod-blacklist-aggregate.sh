#!/bin/bash

# Copyright (C) 2024 Thien Tran
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.

# Combine all sample data for available
sort -u sample-data/vps/available/* > blacklist.txt

# Combine all sample data for necessary
sort -u sample-data/vps/necessary/* > necessary.txt

# Create the list to blacklist 
while read -r KMOD; do
sed -i "s/^${KMOD}$//g" blacklist.txt
done < necessary.txt

# Delete empty lines
sed -i '/^$/d' blacklist.txt

# Module filtering

while read -r KMOD; do
sed -i "s/^${KMOD}.*//g" blacklist.txt
done < kmod-filter-start

while read -r KMOD; do
sed -i "s/.*${KMOD}.*//g" blacklist.txt
done < kmod-filter-all

# Create final blacklist config
while read -r KMOD; do
echo "install ${KMOD} /bin/false" >> blacklist.conf
done < blacklist.txt

# Cleanup
rm necessary.txt blacklist.txt