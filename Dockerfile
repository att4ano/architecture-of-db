FROM postgres:13

RUN apt-get update \
    && apt-get install -y \
        python3 \
        python3-pip \
	python3.11-venv\
        postgresql-plpython3-13 \
	postgresql-server-dev-13 \
	build-essential \
        pgxnclient \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip3 install faker

RUN pgxn install postgresql_faker

COPY roles.sh /roles.sh
RUN chmod +x roles.sh

EXPOSE 5432
