FROM php:7.4.3-cli-alpine3.11

RUN EXPECTED_CHECKSUM="$(wget -q -O - https://composer.github.io/installer.sig)" \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")" \
    && if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then \
        echo 'ERROR: Invalid installer checksum' \
        exit 1 \
    ;fi \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm composer-setup.php \
    && composer global require hirak/prestissimo

ENTRYPOINT ["composer"]