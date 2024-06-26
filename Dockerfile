FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine3.18 AS base
RUN apk update
RUN apk upgrade
RUN apk add tzdata

WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine3.18 AS build
WORKDIR /src
COPY /src .
RUN dotnet restore BaGet
RUN dotnet build BaGet -c Release -o /app

FROM build AS publish
RUN dotnet publish BaGet -c Release -o /app

FROM base AS final
LABEL org.opencontainers.image.source="https://github.com/neurofant-app/BaGet"
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "BaGet.dll"]
