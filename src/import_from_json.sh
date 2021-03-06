#!/bin/bash
set -e
file=$1
if [ ! -f $file ]
then
	echo "ERROR: $file not found"
	exit 1
fi
lens_id=$(cat $file | jq '.bibliographic_data.lens_id' | sed -e 's/"//g')
family_id=$(cat $file | jq '.bibliographic_data.family.simple.family_id' | sed -e 's/"//g')
title0=$(cat $file | jq '.bibliographic_data.title[0].text' | sed -e 's/"//g')
title0_lang=$(cat $file | jq '.bibliographic_data.title[0].lang' | sed -e 's/"//g')
title1=$(cat $file | jq '.bibliographic_data.title[1].text' | sed -e 's/"//g')
title1_lang=$(cat $file | jq '.bibliographic_data.title[1].lang' | sed -e 's/"//g')
title2=$(cat $file | jq '.bibliographic_data.title[2].text' | sed -e 's/"//g')
title2_lang=$(cat $file | jq '.bibliographic_data.title[2].lang' | sed -e 's/"//g')
abstract0=$(cat $file | jq '.abstract[0].text' | sed -e 's/"//g' -e 's/\\/\\\\/g')
abstract0_lang=$(cat $file | jq '.abstract[0].lang' | sed -e 's/"//g')
abstract0=$(cat $file | jq '.abstract[0].text' | sed -e 's/"//g' -e 's/\\/\\\\/g')
abstract1_lang=$(cat $file | jq '.abstract[1].lang' | sed -e 's/"//g')
abstract1=$(cat $file | jq '.abstract[1].text' | sed -e 's/"//g' -e 's/\\/\\\\/g')
abstract2_lang=$(cat $file | jq '.abstract[2].lang' | sed -e 's/"//g')
abstract2=$(cat $file | jq '.abstract[2].text' | sed -e 's/"//g' -e 's/\\/\\\\/g')
claim0_lang=$(cat $file | jq '.claims[0].lang' | sed -e 's/"//g')
claim0=$(cat $file | jq '.claims[0].text' | sed -e 's/"//g' -e 's/\\/\\\\/g')
claim1_lang=$(cat $file | jq '.claims[1].lang' | sed -e 's/"//g')
claim1=$(cat $file | jq '.claims[2].text' | sed -e 's/"//g' -e 's/\\/\\\\/g')
claim2_lang=$(cat $file | jq '.claims[2].lang' | sed -e 's/"//g')
claim2=$(cat $file | jq '.claims[1].text' | sed -e 's/"//g' -e 's/\\/\\\\/g')
description0_lang=$(cat $file | jq '.description[0].lang' | sed -e 's/"//g' )
description0=$(cat $file | jq '.description[0].text' | sed -e 's/"//g' -e 's/\\/\\\\/g')
description1_lang=$(cat $file | jq '.description[1].lang' | sed -e 's/"//g' )
description1=$(cat $file | jq '.description[1].text' | sed -e 's/"//g' -e 's/\\/\\\\/g')
description2_lang=$(cat $file | jq '.description[1].lang' | sed -e 's/"//g' )
description2=$(cat $file | jq '.description[1].text' | sed -e 's/"//g' -e 's/\\/\\\\/g')
echo "lens_id=$lens_id"
#echo "abstract0_lang=$abstract_lang"
#echo "abstract0=$abstract"
#echo "claim0_lang=$abstract_lang"
#echo "claim0=$abstract"
#echo "description0_lang=$description_lang"
#echo "description0=$description"
command="match (p:Patent {LensID:\"$lens_id\"})"
if [ ! "$family_id" = "null" ]
then
	command="$command merge (pf:PatentFamily {id:\"$family_id\"}) merge (p)-[:MEMBER_OF]->(pf)" 
fi
if [ ! "$title0" = "null" ]
then
	 command="$command merge (t0:PatentTitle {id:\"$lens_id-t-$title0_lang\"}) set t0.lang=\"$title0_lang\", t0.text=\"$title0\" merge (p)-[:HAS_TITLE]->(t0)" 
fi
if [ ! "$title1" = "null" ]
then
	 command="$command merge (t1:PatentTitle {id:\"$lens_id-t-$title1_lang\"}) set t1.lang=\"$title1_lang\", t1.text=\"$title1\" merge (p)-[:HAS_TITLE]->(t1)" 
fi
if [ ! "$title2" = "null" ]
then
	 command="$command merge (t2:PatentTitle {id:\"$lens_id-t-$title2_lang\"}) set t2.lang=\"$title1_lang\", t2.text=\"$title1\" merge (p)-[:HAS_TITLE]->(t2)" 
fi
if [ ! "$abstract0" = "null" ]
then
	 command="$command merge (a0:PatentAbstract {id:\"$lens_id-a-$abstract0_lang\"}) set a0.lang=\"$abstract0_lang\", a0.text=\"$abstract0\" merge (p)-[:HAS_ABSTRACT]->(a0)" 
fi
if [ ! "$abstract1" = "null" ]
then
	 command="$command merge (a1:PatentAbstract {id:\"$lens_id-a-$abstract1_lang\"}) set a1.lang=\"$abstract1_lang\", a1.text=\"$abstract1\" merge (p)-[:HAS_ABSTRACT]->(a1)" 
fi
if [ ! "$abstract2" = "null" ]
then
	 command="$command merge (a2:PatentAbstract {id:\"$lens_id-a-$abstract2_lang\"}) set a2.lang=\"$abstract2_lang\", a2.text=\"$abstract2\" merge (p)-[:HAS_ABSTRACT]->(a2)" 
fi
if [ ! "$claim0" = "null" ]
then
	command="$command merge (c0:PatentClaim {id:\"$lens_id-c-$claim0_lang\"}) set c0.lang=\"$claim0_lang\", c0.text=\"$claim0\" merge (p)-[:HAS_CLAIM]->(c0)" 
fi
if [ ! "$claim1" = "null" ]
then
	command="$command merge (c1:PatentClaim {id:\"$lens_id-c-$claim1_lang\"}) set c1.lang=\"$claim1_lang\", c1.text=\"$claim1\" merge (p)-[:HAS_CLAIM]->(c1)" 
fi
if [ ! "$claim2" = "null" ]
then
	command="$command merge (c2:PatentClaim {id:\"$lens_id-c-$claim2_lang\"}) set c2.lang=\"$claim2_lang\", c2.text=\"$claim2\" merge (p)-[:HAS_CLAIM]->(c2)" 
fi
if [ ! "$description0" = "null" ]
then
	command="$command merge (d0:PatentDescription {id:\"$lens_id-d-$description0_lang\"}) set d0.lang=\"$description0_lang\", d0.text=\"$description0\" merge (p)-[:HAS_DESCRIPTION]->(d0)" 
fi
if [ ! "$description1" = "null" ]
then
	command="$command merge (d1:PatentDescription {id:\"$lens_id-d-$description1_lang\"}) set d1.lang=\"$description1_lang\", d1.text=\"$description1\" merge (p)-[:HAS_DESCRIPTION]->(d1)" 
fi
if [ ! "$description2" = "null" ]
then
	command="$command merge (d2:PatentDescription {id:\"$lens_id-d-$description2_lang\"}) set d2.lang=\"$description2_lang\", d2.text=\"$description2\" merge (p)-[:HAS_DESCRIPTION]->(d2)" 
fi
command="$command return p;"
echo "$command" | cypher-shell -a $GC_NEO4J_URL
