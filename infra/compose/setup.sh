git clone https://github.com/docker/compose.git
cd compose
git checkout 1.29.2
sed -i -e 's:^VENV=/code/.tox/py36:VENV=/code/.venv; python3 -m venv $VENV:' script/build/linux-entrypoint
sed -i -e '/requirements-build.txt/ i $VENV/bin/pip install -q -r requirements.txt' script/build/linux-entrypoint
docker build -t docker-compose:aarch64 .