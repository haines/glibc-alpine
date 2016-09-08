FROM alpine:3.4

ENV LANG=C.UTF-8

RUN alpine_glibc_url=https://github.com/sgerrand/alpine-pkg-glibc/releases/download \
 && alpine_glibc_version=2.23-r3 \
 && alpine_glibc_base=glibc-$alpine_glibc_version.apk \
 && alpine_glibc_bin=glibc-bin-$alpine_glibc_version.apk \
 && alpine_glibc_i18n=glibc-i18n-$alpine_glibc_version.apk \
 && alpine_glibc_rsa_key=sgerrand.rsa.pub \

 && apk --no-cache add --virtual=build-dependencies wget ca-certificates \

 && wget $alpine_glibc_url/$alpine_glibc_version/$alpine_glibc_rsa_key \
         --directory-prefix /etc/apk/keys/ \
         --quiet \

 && wget $alpine_glibc_url/$alpine_glibc_version/$alpine_glibc_base \
         $alpine_glibc_url/$alpine_glibc_version/$alpine_glibc_bin \
         $alpine_glibc_url/$alpine_glibc_version/$alpine_glibc_i18n \
         --quiet \

 && apk --no-cache add \
        $alpine_glibc_base \
        $alpine_glibc_bin \
        $alpine_glibc_i18n \

 && rm /etc/apk/keys/$alpine_glibc_rsa_key \
       $alpine_glibc_base \
       $alpine_glibc_bin \
       $alpine_glibc_i18n \

 && /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 $LANG || true \
 && echo "export LANG=$LANG" > /etc/profile.d/locale.sh \

 && apk del glibc-i18n build-dependencies
