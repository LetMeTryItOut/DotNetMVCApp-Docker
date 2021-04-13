FROM mcr.microsoft.com/dotnet/aspnet AS base
WORKDIR /app
#aspnet is the production build image

FROM mcr.microsoft.com/dotnet/sdk AS build
WORKDIR /src
COPY ["DotNetMVCApp.csproj","./"]
RUN dotnet restore "./DotNetMVCApp.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "DotNetMVCApp.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "DotNetMVCApp.csproj" -c Release -o /app

FROM base AS final
ENV ASPNETCORE_URLS=http://*:5000
EXPOSE 5000
WORKDIR /app
COPY --from=publish /app . 
ENTRYPOINT ["dotnet","DotNetMVCApp.dll"]
#. is working directory that is nothing but /app



# Instructions

# 1. Run docker build -t dotnetmvcapp-prod -f prod.dockerFile .
# 2. Run docker run -p 8080:5000 dotnetmvcapp-prod