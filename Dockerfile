FROM mcr.microsoft.com/mssql/server:latest
 
# Set environment variables for SQL
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=test@123
 
EXPOSE 1433

#COPY ./db-init.sql /docker-entrypoint-initdb.d/ 
CMD /opt/mssql/bin/sqlservr
