# Based on https://github.com/linkyard/docker-helm/blob/master/Dockerfile
# and https://github.com/lachie83/k8s-helm/blob/v2.7.2/Dockerfile
# Ensure docker is present, so it can be used from gitlab too
FROM docker:latest
MAINTAINER Diederik van der Boor <opensource@edoburu.nl>

ARG HELM_VERSION=v3.2.4
ARG KUBE_VERSION=v1.18.3
ARG KUSTOMIZE_VERSION=v3.6.1
ARG SKAFFOLD_VERSION=v0.30.0

# Add some basic packages, and allow unzipping helm.
# Make sure helm is initialized so it just works.
# Users can run `helm repo update` in case anything is needed from the stable/ repo.
RUN apk add --update --no-cache ca-certificates curl git tar gzip python3 py-pip sed
RUN \
  curl -Lo /bin/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubectl

RUN \
  curl -Lo /bin/kustomize https://github.com/kubernetes-sigs/kustomize/releases/download/v${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_amd64
RUN \
  curl -Lo /bin/skaffold https://storage.googleapis.com/skaffold/releases/${SKAFFOLD_VERSION}/skaffold-linux-amd64
RUN \
  curl -L https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar zxv -C /bin --strip-components=1 linux-amd64/helm
RUN \
  chmod +x /bin/kubectl /bin/helm /bin/kustomize



COPY create-tmp-image-pull-secret create-kubeconfig create-namespace get-gitlab-settings create-release /bin/

CMD ["/bin/kubectl"]
