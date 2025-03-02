# Use a multi-stage build to reduce image size
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy csproj and restore as distinct layers
COPY ["API_Ecommerce/API_Ecommerce/API_Ecommerce.csproj", "API_Ecommerce/"]
RUN dotnet restore "API_Ecommerce/API_Ecommerce.csproj"

# Copy the rest of the source code
COPY . .
RUN dotnet build "API_Ecommerce/API_Ecommerce/API_Ecommerce.csproj" -c Release -o /app/build

# Publish the application
WORKDIR /src/API_Ecommerce
FROM build AS publish
RUN dotnet publish . -c Release -o /app/publish

# Final stage: create the runtime image
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app

ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://+:5000

# Copy published output from publish stage
COPY --from=publish /app/publish .

# Expose the necessary port
EXPOSE 5000

# Start the app
CMD ["dotnet", "API_Ecommerce.dll"]