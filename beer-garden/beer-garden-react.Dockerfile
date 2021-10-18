FROM node:16

ARG user_uid=1002
ARG install_dir=/home/brewmeister/beer-garden/react-ui
RUN useradd --no-log-init -u $user_uid -m brewmeister && \
    mkdir -p $install_dir && \
    chown $user_uid:$user_uid $install_dir

USER brewmeister
WORKDIR $install_dir

ENTRYPOINT ["bash"]
CMD ["-c", "npm install && npm run start"]
