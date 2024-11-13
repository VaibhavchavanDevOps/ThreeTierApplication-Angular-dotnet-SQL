# Use the official SQL Server image from Microsoft
FROM mcr.microsoft.com/mssql/server:latest
 
# Set environment variables for SQL Server
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=test@123
 
# Expose the default SQL Server port
EXPOSE 1433

#COPY ./db-init.sql /docker-entrypoint-initdb.d/
# Run SQL Server 
CMD /opt/mssql/bin/sqlservr
