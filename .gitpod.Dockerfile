# The main image, using the GitPod default
# If you wanted to VNC into your workspace you could use gitpod/workspace-full-vnc
FROM gitpod/workspace-full

# Bring in Postgres
FROM gitpod/workspace-postgres

# Use the latest Yarn and Node LTS versions
# See https://stackoverflow.com/questions/60908878/webpacker-compilation-failed-error-errno-21-is-a-directory-bin
RUN curl -sL https://deb.nodesource.com/setup_lts.x | sudo bash
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

# Update
RUN sudo apt-get update

# Install what we need
RUN sudo apt-get install -y \
    redis-server build-essential git \
    zlib1g-dev sassc libsass-dev curl yarn nodejs

RUN sudo rm -rf /var/lib/apt/lists/*

USER gitpod

# Install Ruby using the recipe suggestd by GitPod
# Install the Ruby version specified in '.ruby-version'
COPY --chown=gitpod:gitpod .ruby-version /tmp
RUN echo "rvm_gems_path=/home/gitpod/.rvm" > ~/.rvmrc
# TODO - maybe we can just install a specific version here, and update as needed
#RUN bash -lc "rvm install ruby-$(cat /tmp/.ruby-version) && rvm use ruby-$(cat /tmp/.ruby-version) --default"
RUN bash -lc "rvm install ruby-3.1 && rvm use ruby-3.1 --default"
RUN echo "rvm_gems_path=/workspace/.rvm" > ~/.rvmrc

# Install the Stripe CLI see https://stripe.com/docs/stripe-cli
