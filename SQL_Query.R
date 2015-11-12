# This script enables R connection and querying of City databases, assuming the user of the script has access to the City's sql report server.

### Create a connection to City database (replace Buyspeed with desired database).  
myconn<-odbcDriverConnect(connection="Driver={SQL Server Native Client 11.0};
                          server=cno-sqlreport01;database=Buyspeed;
                          trusted_connection=yes;")

## sqlFetch function fetches a database table as is, with connection and table as an arg
Req_dat<-sqlFetch(myconn,"REQ_NOTES")

## sqlQuery function allows a sql query as an argument, with connection as the first arg
PO_dat<-sqlQuery(myconn,"select * from PO_ROUTING where ORG_ID= 'CONTRACTS'")

## BE SURE TO CLOSE THE CONNECTION!  
##If you close the connection, you must reassign the connection before running another query.
close(myconn)
