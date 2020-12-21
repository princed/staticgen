FROM golang:1.14-alpine3.12 as builder

WORKDIR /not-gopath
COPY ./go.mod .
COPY ./go.sum .
RUN go mod download

COPY ./ .
RUN go build ./cmd/staticgen/

FROM alpine:3.12

WORKDIR /root/
COPY --from=builder /not-gopath/staticgen .

RUN mkdir /data
VOLUME /data
WORKDIR /data

ENTRYPOINT ["/root/staticgen"]
