FROM python:3.6-alpine

RUN apk update
RUN apk add postgresql curl bash jq

RUN curl https://sdk.cloud.google.com | bash

COPY backup-database.sh .

# CMD [ "bash" ]

CMD [ "./backup-databse.sh" ]