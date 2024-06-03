FROM alpine:latest

RUN apk add --no-cache postgresql-client
COPY backup.sh /backup.sh
RUN chmod +x /backup.sh

CMD ["sh", "/backup.sh"]