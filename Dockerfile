# Next stage is needed to enable Docker Debug in Fast Mode from Visual Studio and Rider
# See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.
# VS allows to put this stage to any place in Dockerfile and name it as you want (using DockerfileFastModeStage property)
# However, Rider expects it to be the first one (with specific name "base") to use Fast mode (maybe it can be changed somehow)
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["DockerDebugExample/DockerDebugExample.csproj", "DockerDebugExample/"]
RUN dotnet restore "DockerDebugExample/DockerDebugExample.csproj"
COPY . .
WORKDIR "/src/DockerDebugExample"
RUN dotnet build "DockerDebugExample.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DockerDebugExample.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DockerDebugExample.dll"]