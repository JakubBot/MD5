source constants.sh
source utils.sh

paths=()
inaccessible_paths=()
diffrentFiles=()

function generateMD5 {
    # Get the MD5 checksum of the file
    wynik=$(md5sum "$1" | cut -d ' ' -f 1)
    
    echo "$wynik"
}

function generateMD5ForDirectory {
    # Get the MD5 checksum of the directory
    wynik=$(find "${1}" -type f -exec md5sum {} \; | cut -d ' ' -f 1 | md5sum | cut -d ' ' -f 1)
    
    echo "$wynik"
}


# first argument is the file paths(array), first element is the refrence one
function compareFiles {
    # Get the MD5 checksums of the files
    allPaths=("$@")
    
    for path in "${allPaths[@]}"; do
        # Sprawdzenie dostępności ścieżki
        if [ -r "$path" ]; then
            paths+=("$path")
        else
            inaccessible_paths+=("$path")
        fi
    done
    
    pathsSize=${#paths[@]}
    
    if [ $pathsSize -lt 2 ]; then
        zenity --info --text "Podano za mało plików do porównania" --width=$universalInfoWidth --height=200
        return
    fi
    
    refrenceFile="${paths[0]}"
    refrenceMD5=$(generateMD5 "$refrenceFile")
    
    local areFilesEqual=$TRUE
    # i = 1 because the first path is the reference one
    for ((i = 1; i < ${#paths[@]}; i++)); do
        path="${paths[$i]}"
        
        currentMD5=$(generateMD5 "$path")
        
        # Compare the MD5 checksums
        if [ "$refrenceMD5" == "$currentMD5" ]; then
            # all ok
            continue
        else
            areFilesEqual=$FALSE
            diffrentFiles+=("$path")
        fi
    done
    
    if [ $areFilesEqual -eq $TRUE ]; then
        zenity --info --text "Pliki sa takie same \n\nRaport zostal wygenerowany w pliku raport.txt" --width=$universalInfoWidth --height=200
    else
        zenity --info --text "Pliki nie sa takie same \n\nRaport zostal wygenerowany w pliku raport.txt" --width=$universalInfoWidth --height=200
    fi
    generateFileRaport $refrenceFile
    
    # reset
    paths=()
    inaccessible_paths=()
    diffrentFiles=()
    
}

function compareDirectories {
    # /Users/jakubbot/Desktop/MD5/test
    
    directories=("$@")
    
    refrenceDirMD5=$(generateMD5ForDirectory "${directories[0]}")
    
    # i = 1 because the first path is the reference one
    for ((i = 1; i < ${#directories[@]}; i++)); do
        dir="${directories[$i]}"
        
        currentDirMD5=$(generateMD5ForDirectory "$dir")
        
        # Compare the MD5 checksums
        if [ "$refrenceDirMD5" == "$currentDirMD5" ]; then
            zenity --info --text "Foldery sa takie same \n\nRaport zostal wygenerowany w pliku raport.txt" --width=$universalInfoWidth --height=200
            
        else
            zenity --info --text "Foldery nie sa takie same \n\nRaport zostal wygenerowany w pliku raport.txt" --width=$universalInfoWidth --height=200
        fi
    done
    
    
}