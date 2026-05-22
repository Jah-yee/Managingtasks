# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy only csproj first to leverage Docker cache
COPY ["Managingtasks.csproj", "./"]

# Restore dependencies
RUN dotnet restore "Managingtasks.csproj"

# Copy the rest of the project files
COPY . .

# Build the project
RUN dotnet build "Managingtasks.csproj" -c Release -o /app/build

# Stage 2: Publish the application
FROM build AS publish
RUN dotnet publish "Managingtasks.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Stage 3: Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

# Copy published app from previous stage
COPY --from=publish /app/publish .

# Expose port
EXPOSE 5182

# Environment variables
ENV ASPNETCORE_URLS=http://+:5182
ENV ASPNETCORE_ENVIRONMENT=Development

# Optional: Run EF migrations before starting app
# ENTRYPOINT ["sh", "-c", "dotnet ef database update && dotnet Managingtasks.dll"]

# Entry point to start the app
ENTRYPOINT ["dotnet", "Managingtasks.dll"]