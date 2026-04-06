#!/bin/sh

# list all of the files that will be loaded into the database
# for the first part of this assignment, we will only load a small test zip file with ~10000 tweets
# but we will write are code so that we can easily load an arbitrary number of files
files='
test-data.zip
'

echo 'load normalized'
for file in $files; do
    python load_tweets.py --db postgresql+psycopg2://postgres:pass@localhost:58433/postgres --inputs "$file"
done

echo 'load denormalized'
for file in $files; do
    unzip -p "$file" | python -c 'import sys; [sys.stdout.write(line.replace("\\u0000", "")) for line in sys.stdin]' | sed 's/\\/\\\\/g' | psql postgresql://postgres:pass@localhost:58432/postgres -c "\copy tweets_jsonb(data) from stdin"
done
