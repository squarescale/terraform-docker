FROM golang:alpine as terraform-provider-etcdiscovery
RUN apk --update add git openssh \
    && go get -v  github.com/squarescale/terraform-provider-etcdiscovery

FROM hashicorp/terraform
RUN wget -q -O - https://github.com/coreos/terraform-provider-ct/releases/download/v0.2.1/terraform-provider-ct-v0.2.1-linux-amd64.tar.gz \
    | tar zx terraform-provider-ct-v0.2.1-linux-amd64/terraform-provider-ct \
    && mkdir -p /root/.terraform.d/plugins/linux_amd64 \
    && mv terraform-provider-ct-v0.2.1-linux-amd64/terraform-provider-ct /root/.terraform.d/plugins/linux_amd64 \
    && rmdir terraform-provider-ct-v0.2.1-linux-amd64

COPY --from=terraform-provider-etcdiscovery /go/bin/terraform-provider-etcdiscovery /root/.terraform.d/plugins/linux_amd64
