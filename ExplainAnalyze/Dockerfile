FROM mcr.microsoft.com/dotnet/runtime:8.0 AS base
USER $APP_UID
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["ExplainAnalyze/ExplainAnalyze.csproj", "ExplainAnalyze/"]
RUN dotnet restore "ExplainAnalyze/ExplainAnalyze.csproj"
COPY . .
WORKDIR "/src/ExplainAnalyze"
RUN dotnet build "ExplainAnalyze.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "ExplainAnalyze.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ExplainAnalyze.dll"]
