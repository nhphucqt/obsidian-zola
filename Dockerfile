FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    python3 \
    python-is-python3 \
    python3-pip \
    rsync \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN pip3 install python-slugify rtoml

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup install stable
RUN rustup default stable


RUN git clone https://github.com/getzola/zola.git && \
cd zola && \
cargo install --path . --locked && \
zola --version && \
cp target/release/zola ~/.cargo/bin/zola

RUN mkdir /obsidian
COPY . /obsidian-zola

ENV VAULT=/obsidian

EXPOSE 1111

WORKDIR /obsidian-zola

ENTRYPOINT [ "/obsidian-zola/local-run.sh" ]
