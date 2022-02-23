#
#  Copyright (c) 2019 General Electric Company. All rights reserved.
#
#  The copyright to the computer software herein is the property of
#  General Electric Company. The software may be used and/or copied only
#  with the written permission of General Electric Company or in accordance
#  with the terms and conditions stipulated in the agreement/contract
#  under which the software has been supplied.
#
#  author: apolo.yasuda@ge.com
#

FROM rust:alpine
USER root
WORKDIR /root

COPY ./index.sh ./Cargo.toml ./
COPY ./src/* ./sac/src/

#RUN apk update && apk add wget tree
RUN apt-get update && apt-get install -y wget tree

RUN rust --version && rustup override set nightly && \
cd ./sac && cargo build --release && \
cd -

RUN chmod +x ./index.sh

ENTRYPOINT ["./index.sh"]
