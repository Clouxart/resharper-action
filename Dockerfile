FROM golang:1.14 AS builder

WORKDIR /build
COPY . .
RUN CGO_ENABLED=0 go build -ldflags="-s -w"
RUN ls -lh

FROM mcr.microsoft.com/dotnet/sdk:5.0
ENV RESHARPER_CLI_VERSION=2021.2.1

RUN mkdir -p /usr/local/share/dotnet/sdk/NuGetFallbackFolder

WORKDIR /resharper
RUN dotnet tool install --global JetBrains.ReSharper.GlobalTools --version $RESHARPER_CLI_VERSION
ENV PATH="/$HOME/.dotnet/tools:${PATH}"

# this is the same as the base image
WORKDIR /

COPY --from=builder /build/resharper-action /usr/bin
CMD resharper-action
