[xml]$conf = Get-Content .\config.xml

$sqlHost = $conf.config.sql.host
$sqlUser = $conf.config.sql.user
$sqlPw = $conf.config.sql.password

$pssql = ".\psdb\pssql.ps1"

. $pssql -psqlHost $sqlHost -psqlUser $sqlUser -psqlPassword $sqlPw

$result = Execute-Query -database "ninjadb" -sqlCommand "SELECT TOP 20 * FROM fancy_table;"

