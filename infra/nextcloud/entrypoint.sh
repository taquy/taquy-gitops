
# Run base image entrypoint
sh /entrypoint.sh

# execute config script
for FILE in /config; do bash $FILE; done