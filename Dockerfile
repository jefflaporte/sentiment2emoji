FROM demisto/python3:3.7.3.286

COPY requirements.txt .

RUN apk --update add --no-cache --virtual .build-dependencies python3-dev build-base wget git g++ python3-dev\
        openssh curl ca-certificates openssl less htop \
    		make  rsync \
        libpng-dev freetype-dev libexecinfo-dev lapack-dev \
        gfortran \
        musl-dev \
        && apk add --no-cache libstdc++  \
        && apk add --no-cache libgomp \
        && apk add --no-cache bash  \
        && ln -s /usr/include/locale.h /usr/include/xlocale.h

COPY requirements.txt /tmp
RUN pip3 install -r /tmp/requirements.txt

WORKDIR /app
COPY ./app.py .
COPY ./gb_model.sklearn .
COPY ./tfidf.sklearn .

EXPOSE 8080
ENV PORT 8080
ENV FLASK_ENV production

CMD ["python3", "/app/app.py"]
