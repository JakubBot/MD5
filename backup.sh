

function createBackup {
    local backupDir=$1
    
    local dirName=$(echo "$backupDir" | sed "s/\//$slashToCodeConverter/g")
    
    
    tar -czf "backup/$dirName.tar.gz" -C "$(dirname "$backupDir")" "$(basename "$backupDir")"
    
    zenity --info --text "Kopia zapasowa utworzona" --width=200 --height=200
    
}

function findChangesInFolder {
    local userDirectory=$1
    
    # first check if folder and backup folder are the same
    local backupFileName=$(filenameToBackupConverter "$userDirectory")
    
    local userDirectoryMD5=$(generateMD5ForDirectory "$userDirectory")
    local backupMD5=$(generateMD5ForTar "backup/$backupFileName.tar.gz")
    
    local isEqual=-1
    if [ "$userDirectoryMD5" == "$backupMD5" ]; then
        isEqual=$TRUE
        zenity --info --text "Brak zmian w folderze" --width=200 --height=200
    else
        isEqual=$FALSE
        zenity --info --text "Znaleziono zmiany w folderze" --width=200 --height=200
    fi
    
    generateRaportBackupFolders "$userDirectory" "$isEqual"
    
}