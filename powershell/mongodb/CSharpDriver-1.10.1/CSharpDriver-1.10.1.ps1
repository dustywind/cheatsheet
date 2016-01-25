
param(
    [string] $mongoDriverPath="D:\libs\mongoDB\CSharpDriver-1.10.1\"
)

Add-Type -Path "$($mongoDriverPath)MongoDB.Bson.dll";
Add-Type -Path "$($mongoDriverPath)MongoDB.Driver.dll";

function Create-MongoHelper {
    param(
        [Parameter(Mandatory=$true)] [string] $mongoHost,
        [string] $mongoUser=$null,
        [string] $mongoPassword=$null,
        [string] $authDatabase='admin',
        [string] $mongoOptions=$null
    )
    
    $properties = [ordered]@{
        Host = $mongoHost
        User = $mongoUser
        Password = $mongoPassword
        AuthDatabase = $authDatabase='admin'
        Options = $mongoOptions
    }
    $object = New-Object -TypeName PSObject -Property $properties
    
    $connectionStrScript = {
        $connectionString = 'mongodb://'
        if($this.User -and $this.Password){
            $connectionString += "$($this.User):$($this.Password)@"
        }
        $connectionString += $mongoHost

        $connectionString += "/$($this.AuthDatabase)"

        if($this.Options){
            $connectionString += "?$($this.Options)"
        }
        return $connectionString
    }
    $object | Add-Member -MemberType ScriptMethod `
                -Name 'GetConnectionString' `
                -Value $connectionStrScript

    $collectionScript = {
        param(
            [string] $dbName,
            [string] $collectionName
        )
    
        $client = New-Object MongoDB.Driver.MongoClient($this.GetConnectionString())
        $server = $client.GetServer()
        $db = $server.GetDatabase($dbName)
        $collection = $db.GetCollection($collectionName)
        return $collection
    }
    $object | Add-Member -MemberType ScriptMethod `
                -Name 'GetCollection' `
                -Value $collectionScript
    
    $queryDocumentScript = {
        param(
            $queryDict
        )
        $qd = New-Object MongoDB.Driver.QueryDocument($queryDict)
        return ,$qd
        return New-Object MongoDB.Driver.QueryDocument($queryDict)
    }
    $object | Add-Member -MemberType ScriptMethod `
                -Name 'GetQueryDocument' `
                -Value $queryDocumentScript
    
    $cursorToListScript = {
        param(
            [MongoDB.Driver.MongoCursor] $mongoCursor
        )
        return New-Object 'System.Collections.Generic.List`1[MongoDB.Bson.BsonDocument]' `
            -ArgumentList $mongoCursor
    }
    $object | Add-Member -MemberType ScriptMethod `
                -Name 'CursorToList' `
                -Value $cursorToListScript
    return $object
}

