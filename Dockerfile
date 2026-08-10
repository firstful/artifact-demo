FROM golang:1.24-alpine AS build
WORKDIR /src
COPY go.mod main.go ./
RUN CGO_ENABLED=0 go build -trimpath -ldflags "-s -w" -o /demo-bin .

FROM scratch
COPY --from=build /demo-bin /demo-bin
ENTRYPOINT ["/demo-bin"]
