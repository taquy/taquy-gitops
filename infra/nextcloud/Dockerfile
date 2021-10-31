FROM nextcloud

USER www-data

VOLUME [ "/config" ]

# Copy scripts
COPY ./entrypoint.sh /entrypoint-wrapper.sh

ENTRYPOINT ["/entrypoint-wrapper.sh"]