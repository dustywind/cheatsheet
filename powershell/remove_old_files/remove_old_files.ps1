
$path = 'D:/Temp/test'
$filter = '*'
$recursive = $true
$threshold = [DateTime]::Parse("2016-01-18")

function SelectiveRemove($info){
    begin {}
    process
    {
        if($_ -is [System.IO.DirectoryInfo])
        {
            if (DirectoryIsRemoveable($_))
            {
                $_
            }
            elseif($recursive)
            {
                Remove($_.FullName)
            }
        }
        elseif($_ -is [System.IO.FileInfo])
        {
            if(FileIsRemoveable($_))
            {
                $_
            }
        }
    }
    end {}
}

function DirectoryIsRemoveable([System.IO.DirectoryInfo] $dirInfo)
{
    if($dirInfo.GetFiles().Count -gt 0 -or $dirInfo.GetDirectories().Count -gt 0)
    {
        return $false
    }
    return $true
}

function FileIsRemoveable([System.IO.FileInfo] $fileInfo)
{
    $date = EarliestDateFromFileInfo($_)
    if($date -lt $threshold)
    {
        return $true
    }
    return $false
}


function Remove($path)
{
    Get-ChildItem $path -Filter $filter `
        | SelectiveRemove `
        | ForEach-Object `
        {
            if($_ -is [System.IO.FileSystemInfo])
            {
                write-host $_.FullName
                $_.Delete()
            }
        }
}

function EarliestDateFromFileInfo([System.IO.FileInfo] $finfo)
{
    begin{}
    process
    {
        $dates = @($finfo.CreationTime,$finfo.LastAccessTime,$finfo.LastWriteTime)
   
        $earliest = $dates[0]
        foreach($date in $dates)
        {
            if($date -lt $earliest)
            {
                $earliest = $date
            }
        }
        $earliest
    }
    end{}
}


Remove($path)
