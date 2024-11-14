FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build

WORKDIR /app

COPY *.csproj .
RUN dotnet restore

COPY . .

# Build the application
RUN dotnet publish -c Release -o out
RUN dotnet tool install --global dotnet-ef --version 3.1
ENV PATH="$PATH:/root/.dotnet/tools"
RUN dotnet ef migrations add InitialCreate
RUN dotnet ef database update

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS runtime

WORKDIR /app

COPY --from=build /app/out .

EXPOSE 80
EXPOSE 443
# Set the entry point for the container
ENTRYPOINT ["dotnet", "ElectricEquipmentDotNetCoreProject.dll"]
