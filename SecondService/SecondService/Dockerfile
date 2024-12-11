# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy the solution file and restore dependencies
COPY ["SecondService.csproj", "./"]
RUN dotnet restore './SecondService.csproj' 

COPY . ./
WORKDIR /src
RUN dotnet build 'SecondService.csproj' -c Release -o /app/build

# Copy the entire source code and build the app
COPY . ./
WORKDIR /src
RUN dotnet publish 'SecondService.csproj' -c Release -o /app/publish

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
ENV ASPNETCORE_HTTP_PORTS=5002
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "SecondService.dll"]
