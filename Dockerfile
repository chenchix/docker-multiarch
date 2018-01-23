FROM golang:1.8-alpine3.6
WORKDIR /go/src/
COPY . .
ARG ARCH
RUN if [[ "${ARCH}"X == "x86_64"X ]]; then cd src && GO_ENABLED=0 GOOS=linux go build -ldflags "-s" -a -installsuffix cgo -o exe;  \
else cd src && GOARCH=arm64 CGO_ENABLED=0 GOOS=linux go build -ldflags "-s" -a -installsuffix cgo -o exe; fi

FROM scratch

COPY --from=0 /go/src/src/exe /

ENTRYPOINT ["/exe"]
