#!/bin/bash
set -e
URLS="https://lens-public.s3.us-west-2.amazonaws.com/coronavirus/patent/fulltext/Coronavirus-broad-keyword-based-patents.zip https://lens-public.s3.us-west-2.amazonaws.com/coronavirus/patent/fulltext/Coronavirus-patents-SARS-and-MERS.zip https://lens-public.s3.us-west-2.amazonaws.com/coronavirus/patent/fulltext/Coronavirus-patents-SARS-and-MERS-TAC.zip https://lens-public.s3.us-west-2.amazonaws.com/coronavirus/patent/fulltext/Coronavirus-limited-keywords-based-patents.zip https://lens-public.s3.us-west-2.amazonaws.com/coronavirus/patent/fulltext/Coronavirus-CPC-based-patents.zip https://lens-public.s3.us-west-2.amazonaws.com/coronavirus/patent/fulltext/Coronavirus-declared-patseq-organism.zip https://lens-public.s3.us-west-2.amazonaws.com/coronavirus/patent/fulltext/Coronavirus-SARS-patents.zip https://lens-public.s3.us-west-2.amazonaws.com/coronavirus/patent/fulltext/Coronavirus-MERS-patents.zip https://lens-public.s3.us-west-2.amazonaws.com/coronavirus/patent/fulltext/Coronavirus-SARS-diagnosis-patents.zip https://lens-public.s3.us-west-2.amazonaws.com/coronavirus/patent/fulltext/Coronavirus-MERS-diagnosis-patents.zip https://lens-public.s3.us-west-2.amazonaws.com/coronavirus/patent/fulltext/Coronavirus-SARS-treatment.zip https://lens-public.s3.us-west-2.amazonaws.com/coronavirus/patent/fulltext/Coronavirus-MERS-treatment.zip https://lens-public.s3.us-west-2.amazonaws.com/coronavirus/patent/fulltext/Ventilators.zip https://lens-public.s3.us-west-2.amazonaws.com/coronavirus/patent/fulltext/Ventilators.zip"
[ ! -d zip ] && mkdir zip
base=$(pwd)
cd zip
for url in $URLS
do
	echo "Importing fulltext from $url"
	zipfile=$(basename $url)
    file=$(basename $zipfile .zip)
    if [ -f $zipfile ]
    then
		echo "File $zipfile already exists"
    else
		echo "Downloading $url to $zipfile"
		wget $url
	fi
    echo "Unzipping file $zipfile"
    unzip -o $zipfile
    (
    	cd $file
		cwd=$(pwd)
		find . -name "*.json" | xargs -n1 | while read json
		do
			echo "Importing file $json"
			$base/import_from_json $json
		done
	)	
    echo "Deleting downloaded file $file"
	#rm $file
done
