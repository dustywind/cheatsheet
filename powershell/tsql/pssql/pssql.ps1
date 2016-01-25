

param(
    [string] $psqlHost,
    [string] $psqlUser,
    [string] $psqlPassword
)


function Execute-Query {
    param(
        [string] $database = "MasterData",
        [string] $sqlCommand = $(throw "Please specify a query.")
    )

    $connectionString = "Data Source=$psqlHost;" +
        #"Integrated Security=SSPI; " +
        "User ID=$psqlUser;" +
        "Password=$psqlPassword;" + 
        "Initial Catalog=$database"

    $connection = new-object system.data.SqlClient.SQLConnection($connectionString)
    $command = new-object system.data.sqlclient.sqlcommand($sqlCommand,$connection)
    $connection.Open()

    $adapter = New-Object System.Data.sqlclient.sqlDataAdapter $command
    $dataset = New-Object System.Data.DataSet
    $adapter.Fill($dataSet) | Out-Null

    $connection.Close()
    $dataSet.Tables

}
