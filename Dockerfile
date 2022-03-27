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

FROM rust:slim
USER root
WORKDIR /root

COPY ./Cargo.toml ./
COPY ./sac/ ./sac/

RUN rustup override set nightly && \
cargo build --release --all-features && tree ./

RUN echo 'export PATH=$PATH:$HOME/.ec' >> /etc/profile && apt-get update && apt-get install -y wget tree bash && \
mkdir -p ~/.ec && echo '#!/bin/bash' > ./~sac && \
echo 'source <(wget -q -O - https://raw.githubusercontent.com/ayasuda-ge/sac/main/index.sh) "$@"' >> ./~sac && \
chmod +x ./~sac  

ENTRYPOINT ["./~sac"]
