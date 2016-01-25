

$mongodriver = './CSharpDriver-1.10.1/CSharpDriver-1.10.1.ps1'
. $mongodriver

[xml]$conf = Get-Content .\config.xml

$mongoHost = $conf.config.mongo.host
$mongoUser = $conf.config.mongo.user
$mongoPw = $conf.config.mongo.password

$databaseName = 'Olymptest_Stage1'
$collectionName = 'OlympStage1'

$helper = Create-MongoHelper $mongoHost $mongoUser $mongoPw

$conStr = $helper.GetConnectionString()

$c = $helper.GetCollection($databaseName, $collectionName)

$d = New-Object System.DateTime(2015, 10, 10, 0, 0, 0, [System.DateTimeKind]::Utc)
$queryDic = @{ 
    'a'=100
    ; 'b'=$d
    ; '$or'=@(@{'foo.bar'=202948},@{'foo.bar'=202760})
}
$query = $helper.GetQueryDocument($queryDic)

$c.Count($query)

$c.Count()

$rcursor = $c.Find($query)

$rlist = $helper.CursorToList($rcursor)

for($i = 0; $i -lt $rlist.Count; $i += 1) {
    Write-Host $rlist[$i]['foo']['bar']
}
