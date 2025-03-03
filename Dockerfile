FROM alpine

# Install dependencies
RUN apk --update add git zola python3 rsync py3-pip curl g++ && \
    python3 -m venv /venv && \
    . /venv/bin/activate && \
    pip install python-slugify rtoml && \
    # git clone https://github.com/nhphucqt/obsidian-zola && \
    mkdir /obsidian

COPY . /obsidian-zola

ENV VAULT=/obsidian

# Install Rust and obsidian-export
RUN curl -sSf https://sh.rustup.rs | sh -s -- -y && \
    source $HOME/.cargo/env && \
    cargo install obsidian-export

ENV PATH="$HOME/.cargo/bin:$PATH"

# Copy entrypoint script
COPY entrypoint.sh /
RUN cp $HOME/.cargo/bin/obsidian-export /obsidian-zola/bin/obsidian-export && \
    sed -i 's|zola --root=build serve|zola --root=build serve --interface 0.0.0.0 --base-url $SITE_URL|' /obsidian-zola/local-run.sh && \
    chmod +x /entrypoint.sh

EXPOSE 1111
WORKDIR /obsidian-zola

ENTRYPOINT [ "/entrypoint.sh" ]
