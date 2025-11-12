#!/bin/bash
word="$1"
curl -s "https://www.openthesaurus.de/synonyme/search?q=$word&format=application/json" | jq '.synsets[].terms[].term'

