# Stage 1 - Build
# choose base image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

#create dir in container
WORKDIR /src

# restore (restore dependencies)
COPY ["/project_dir/csproj_file.csproj", "./"] 
# all will be in WORKDIR
# or
COPY ["/project_dir/csproj_file.csproj", "folder_name/"]
# all will be in WORKDIR/folder_name
RUN dotnet restore 'folder_name/csproj_file.csproj' 
#or
RUN dotnet restore './csproj_file.csproj'

# build 
COPY ["project_dir", "folder_name/"]
WORKDIR /folder_name
RUN dotnet build 'csproj_file.csproj' -c Release -o /app/build

# Stage 2 - Publish
FROM build as publish
WORKDIR /folder_name
RUN dotnet publish 'csproj_file.csproj' -c Release -o /app/publish

# Stage 3 - Run
FROM mcr.microsoft.com/dotnet/aspnet:8.0 as runtime
ENV ASPNETCORE_HTTP_PORTS=5001
EXPOSE 5001
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "csproj_file.dll"]

