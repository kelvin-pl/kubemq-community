FROM golang:1.20 as builder
ARG GITHUB_RUN_NUMBER
ENV VERSION=v2.4.0.$GITHUB_RUN_NUMBER
ARG GIT_COMMIT
ARG BUILD_TIME
ENV GOPATH=/go
ENV PATH=$GOPATH:$PATH
ENV ADDR=0.0.0.0
WORKDIR $GOPATH/github.com/kubemq-io/kubemq-community
ADD . .
RUN go mod vendor
RUN CGO_ENABLED=0 go build -a -mod=vendor -installsuffix cgo -ldflags="-w -s -X main.version=$VERSION" -o kubemq-run .
FROM scratch
ENV GOPATH=/go
ENV PATH=$GOPATH/bin:$PATH
COPY --from=builder $GOPATH/github.com/kubemq-io/kubemq-community/kubemq-run /
EXPOSE 50000
EXPOSE 9090
EXPOSE 8080
CMD ["/kubemq-run","server"]

