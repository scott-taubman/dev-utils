FROM node:14

ARG user_uid=1002
ARG install_dir=/home/brewmeister/beer-garden/ui
RUN useradd --no-log-init -u $user_uid -m brewmeister && \
    mkdir -p $install_dir && \
    chown $user_uid:$user_uid $install_dir
USER brewmeister
WORKDIR $install_dir

ENTRYPOINT ["bash"]
CMD ["-c", "npm install && npm run env -- webpack-dev-server --config /home/brewmeister/beer-garden/ui/webpack.dev-utils.js"]
