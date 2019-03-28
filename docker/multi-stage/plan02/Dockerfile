FROM golang AS build-env
WORKDIR /go/app/demo
COPY ./demo /go/app/demo
RUN export GO111MODULE=on && go mod tidy
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0  go build -v -o /go/app/godemo

FROM alpine
RUN apk add -U tzdata
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
COPY --from=build-env /go/app/godemo /root/godemo
EXPOSE 8080
CMD [ "/root/godemo"]