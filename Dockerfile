FROM golang:1.14 AS builder

WORKDIR /build
COPY . .
RUN CGO_ENABLED=0 go build -ldflags="-s -w"
RUN ls -lh

FROM mcr.microsoft.com/dotnet/sdk:5.0
ENV RESHARPER_CLI_VERSION=2021.2.1

RUN mkdir -p /usr/local/share/dotnet/sdk/NuGetFallbackFolder

WORKDIR /resharper
RUN apt-get update
RUN apt-get install fastjar
RUN \
  curl -o resharper.zip -L "https://download.jetbrains.com/resharper/ReSharperUltimate.$RESHARPER_CLI_VERSION/JetBrains.ReSharper.CommandLineTools.Unix.$RESHARPER_CLI_VERSION.zip" 
  RUN jar xvf  resharper.zip \
  && rm resharper.zip \
  && rm -rf macos-x64
ENV PATH="/resharper:${PATH}"

# this is the same as the base image
WORKDIR /

COPY --from=builder /build/resharper-action /usr/bin
CMD resharper-action
