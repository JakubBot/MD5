source constants.sh



function generateMD5 {
    # Get the MD5 checksum of the file
    wynik=$(md5sum "$1" | cut -d ' ' -f 1)
    
    echo "$wynik"
}

function generateMD5ForDirectory {
    # Get the MD5 checksum of the directory
    wynik=$(find "${1}" -type f -exec md5sum {} \; | cut -d ' ' -f 1 | md5sum | cut -d ' ' -f 1)
    # wynik=$(find "$1" -type f -exec md5sum {} \; | sort -k 2 | md5sum | cut -d ' ' -f 1)
    
    echo "$wynik"
}


# first argument is the file paths(array), first element is the refrence one
function compareFiles {
    # Get the MD5 checksums of the files
    paths=("$@")
    
    # refrenceMD5=$(md5sum "${paths[0]}" | cut -d ' ' -f 1)
    refrenceMD5=$(generateMD5 "${paths[0]}")
    
    # i = 1 because the first path is the reference one
    for ((i = 1; i < ${#paths[@]}; i++)); do
        path="${paths[$i]}"
        
        currentMD5=$(generateMD5 "$path")
        
        # Compare the MD5 checksums
        if [ "$refrenceMD5" == "$currentMD5" ]; then
            zenity --info --text "Pliki sa takie same \n\nRaport zostal wygenerowany w pliku raport.txt" --width=$universalInfoWidth --height=200
        else
            zenity --info --text "Pliki nie sa takie same \n\nRaport zostal wygenerowany w pliku raport.txt" --width=$universalInfoWidth --height=200
        fi
    done
    
}

function compareDirectories {
    # /Users/jakubbot/Desktop/MD5/test
    
    #  "/Users/jakubbot/Desktop/MD5/test/bbb" -type f -exec md5sum {} \; | sort -k 2 | md5sum | cut -d ' ' -f 1
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