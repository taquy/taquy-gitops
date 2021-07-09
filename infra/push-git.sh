#!/usr/bin/env bash

COMMENT=$1
COMMIT_ID=$(date +%s)

git add .
git commit -m "$COMMIT_ID $COMMENT"
git push --force origin master
