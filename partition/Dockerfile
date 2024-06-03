FROM alpine:latest

RUN apk add --no-cache postgresql-client
COPY partition.sh /partition.sh 

RUN chmod +x /partition.sh 

CMD ["sh", "/partition.sh"]