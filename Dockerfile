# Get Base Image (Full .NET Core SDK)
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["WeatherForecastAPI.csproj", "."]
RUN dotnet restore "./WeatherForecastAPI.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "WeatherForecastAPI.csproj" -c Release -o /app/build
FROM build AS publish
RUN dotnet publish "WeatherForecastAPI.csproj" -c Release -o /app/publish
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "WeatherForecastAPI.dll"]