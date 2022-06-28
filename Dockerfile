# Stage 1: Creating build image
# Pulling base image with SDK dependencies required
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
# Setting work directory
WORKDIR /build
# Copying all files for the build
COPY . .
# Restoring dependencies for the app
RUN dotnet restore
# Publishing the app to the app folder
RUN dotnet publish -c Release -o /app
# Stage 2: Creating the final image for deployment
# Pulling base image with framework (not SDK) dependencies required
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS final
# Setting work directory
WORKDIR /app
# Copying the app files from the build image to the app directory
COPY --from=build /app .
# Passing command to container for running the web app
ENTRYPOINT ["dotnet", "TodoApi.dll"]