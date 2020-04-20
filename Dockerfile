FROM marceloagmelo/golang-1.13 AS builder

LABEL maintainer="Marcelo Melo marceloagmelo@gmail.com"

USER root

ENV APP_HOME /go/src/github.com/marceloagmelo/go-hello

ADD app $APP_HOME

WORKDIR $APP_HOME

RUN go mod init && \
    go install && \
    rm -Rf /tmp/* && rm -Rf /var/tmp/*

###
# IMAGEM FINAL
###
FROM centos:7

ENV GID 23550
ENV UID 23550
ENV USER golang

ENV GOBIN /go/bin
ENV APP_HOME /opt/app
ENV IMAGE_SCRIPTS_HOME /opt/scripts

ADD scripts $IMAGE_SCRIPTS_HOME

WORKDIR $APP_HOME

COPY --from=builder $GOBIN/go-hello $APP_HOME/go-hello
COPY app/form $APP_HOME/form
COPY Dockerfile $IMAGE_SCRIPTS_HOME/Dockerfile

RUN groupadd --gid $GID $USER && useradd --uid $UID -m -g $USER $USER && \
    chown -fR $USER:0 $APP_HOME && \
    chown -fR $USER:0 $IMAGE_SCRIPTS_HOME && \
    rm -Rf /tmp/* && rm -Rf /var/tmp/*

ENV PATH $APP_HOME:$PATH

EXPOSE 8080

USER $USER

WORKDIR $IMAGE_SCRIPTS_HOME

ENTRYPOINT [ "./control.sh" ]
CMD [ "start" ]
