function Upload-Folder {
    Param($path)

    if (-not ($path | Test-Path)) {
        Write-Host "Invalid Path Supplied " + $path
        return
    }
    else {
        $folder = Split-Path $path -Leaf
        $containerName = "cnt-"+$folder

        Write-Host "You choose to upload " + $f +  " to blob";

        try {
            $storageAccount = Get-AzStorageAccount -ResourceGroupName "rg" -Name "stgpervaze"
            $ctx = $storageAccount.Context
            Write-Host "Creating Container $containerName"
    
            $container = New-AzStoragecontainer -Name $containerName -Context $ctx -Permission blob
            Write-Host "Container $containerName created sucessfully"

            Upload-Files $path, $ctx, $containerName
        }
        catch {
            Write-Host "Creation of Container $containerName failed, container already exists"
        }
    }
}

# function Upload-Files
# {
#     Param($path, $ctx, $container)
#     Get-ChildItem $path *.* -rec | where { ! $_.PSIsContainer } | ForEach-Object {
#         #ploading 
#         $filePath = $_.FullName
#         $blob = $_.Name
#         Write-Host "Uploading " + $filePath + "as " + $blob

#         try {
#             set-AzStorageblobcontent -File $filePath `
#             -Container $container `
#             -Blob $blob `
#             -Context $ctx -ErrorAction stop

#             Write-Host $blob + " Uploaded"
#         }
#         catch
#         {
#             Write-Host "ERROR Uploading $blob"
#         }
#     }

# }

function Upload-Files {
    Param($path)
    # $fileName = Split-Path $path -leaf

    $storageAccount = Get-AzStorageAccount -ResourceGroupName "rg" -Name "stgpervaze"
    $ctx = $storageAccount.Context

    # set-AzStorageblobcontent -File $path -Container "cnt-target" -Blob $fileName -Context $ctx

    Get-ChildItem $path *.* -rec | where { ! $_.PSIsContainer } | ForEach-Object {
        $filePath = $_.FullName
        $fileName = $_.Name
        $targetPath = ($filePath.Substring($path.Length + 1)).Replace("\", "/")
        set-AzStorageblobcontent -File $filePath -Container "cnt-target" -Blob $targetPath -Context $ctx
    }
}

# Do-Something
#Upload-ToBlob -folder target
#Create-Container "hello"
Upload-Folder "target"

