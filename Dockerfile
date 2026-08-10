FROM golang:1.24-alpine AS build
WORKDIR /src
COPY go.mod main.go ./
ARG VERSION=dev
RUN CGO_ENABLED=0 go build -trimpath -ldflags "-s -w -X main.version=${VERSION}" -o /demo-bin .

FROM scratch
COPY --from=build /demo-bin /demo-bin
ENTRYPOINT ["/demo-bin"]
