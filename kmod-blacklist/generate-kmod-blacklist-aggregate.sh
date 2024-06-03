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

output(){
    echo -e '\e[36m'"$1"'\e[0m';
}

dataset_selection() {
    output 'Which dataset do you want to generate the kmod blacklist for?'
    output '1) VPS'
    output '2) Workstation'
    output 'Insert the number of your selection:'
    read -r choice
    case $choice in
        1 ) dataset='vps'
            ;;
        2 ) dataset='workstation'
            ;;
        * ) output 'You did not enter a valid selection.'
            dataset_selection
    esac
}

dataset_selection

# Combine all sample data for available
sort -u sample-data/"${dataset}"/available/* > blacklist.txt

# Combine all sample data for necessary
sort -u sample-data/vps/necessary/* > necessary.txt

# Create the list to blacklist 
while read -r KMOD; do
sed -i "s/^${KMOD}$//gm" blacklist.txt
done < necessary.txt

# Module filtering

while read -r KMOD; do
sed -i "s/^${KMOD}.*//gm" blacklist.txt
done < kmod-filter-start

while read -r KMOD; do
sed -i "s/.*${KMOD}.*//gm" blacklist.txt
done < kmod-filter-all

# Delete empty lines
sed -i '/^$/d' blacklist.txt

# Create final blacklist config
while read -r KMOD; do
echo "install ${KMOD} /bin/false" >> "${dataset}"-blacklist.conf
done < blacklist.txt

# Cleanup
rm necessary.txt blacklist.txt