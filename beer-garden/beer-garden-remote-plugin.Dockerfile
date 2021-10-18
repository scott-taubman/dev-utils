# beer-garden development image
# This Dockerfile assumes that the docker-compose.yml in this project is used
# to start things, and thus neede volume mounts etc. will be in place. It is
# not intended as a general purpose Dockerfile.
FROM python:3.7-slim

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

# initial setup
ARG user_uid=1002
ARG install_dir=/home/brewmeister/beer-garden/plugins
RUN apt-get -y update && \
    apt-get install -y git make procps && \
    useradd --no-log-init -u $user_uid -m brewmeister && \
    mkdir -p $install_dir && \
    chown $user_uid:$user_uid $install_dir
USER brewmeister
WORKDIR $install_dir
RUN echo "source /home/brewmeister/venv/bin/activate" >> /home/brewmeister/.bashrc

# pip installs
COPY requirements.txt $install_dir/
RUN python -m venv /home/brewmeister/venv && \
    bash -c "source /home/brewmeister/venv/bin/activate && pip install ipdb remote-pdb web-pdb" && \
    bash -c "source /home/brewmeister/venv/bin/activate && pip install -r $install_dir/requirements.txt"

ENTRYPOINT ["bash"]
CMD ["-c", "source /home/brewmeister/venv/bin/activate && /opt/scripts/move_sitecustomize.sh && /home/brewmeister/beer-garden/plugins/entrypoint.sh"]
