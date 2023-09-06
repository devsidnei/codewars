# Dockerfile para um ambiente de desenvolvimento PHP
#
# Versão: 1.0.0

# Imagem base
FROM php:8.2-fpm

# Argumentos
ARG user
ARG uid

# Instalar o Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# Criar usuário do sistema
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Definir diretório de trabalho
WORKDIR /var/www

# Configurar o Xdebug
COPY ./.docker/php/php.ini /usr/local/etc/php/conf.d/custom.ini

# Expor portas
EXPOSE 9000

# Definir usuário do sistema
USER $user

# Entry point para executar o PHP-FPM
CMD ["php-fpm"]

# Explicações

# * **FROM php:8.2-fpm as php:** Define a imagem base para a construção. No caso, a imagem PHP 8.2-fpm, que fornece um servidor web PHP-FPM pré-configurado.
# * **ARG user=sidnei:** Define uma variável de ambiente chamada `user`. Essa variável será usada para definir o nome e o ID do usuário do sistema que será criado para executar comandos do Composer e Artisan.
# * **ARG uid=1000:** Define outra variável de ambiente chamada `uid`. Essa variável será usada para definir o ID do usuário do sistema que será criado.
# * **RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer:** Instala o Composer, um gerenciador de pacotes para PHP.
# * **RUN useradd -G www-data,root -u $uid -d /home/$user $user && RUN mkdir -p /home/$user/.composer && \
#     chown -R $user:$user /home/$user:** Cria um usuário do sistema chamado `sidnei` com ID 1000. O usuário será membro do grupo `www-data`, que tem permissão para acessar arquivos de aplicativos web. O diretório `/home/$user` será criado para o usuário e seus arquivos serão gravados com permissões de proprietário e grupo `$user:$user`.
# * **WORKDIR /var/www:** Define o diretório de trabalho padrão para o container.
# * **COPY php.ini /usr/local/etc/php/conf.d/custom.ini:** Copia o arquivo `php.ini` para o diretório de configuração do PHP. O arquivo `php.ini` pode ser usado para configurar opções de execução do PHP.
# * **EXPOSE 9000:** Expor a porta 9000 para o container. A porta 9000 é usada pelo xdebug para depuração remota.
# * **USER $user:** Define o usuário do sistema que será usado para executar o container.