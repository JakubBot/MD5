
function generateMD5 {
    # Get the MD5 checksum of the file
    wynik=$(md5sum "$1" | cut -d ' ' -f 1)
    
    echo "$wynik"
}


# first argument is the file paths(array), first element is the refrence one
function compareFiles {
    # Get the MD5 checksums of the files
    paths=("$@")
    
    echo "paths $paths"
    
    # refrenceMD5=$(md5sum "${paths[0]}" | cut -d ' ' -f 1)
    refrenceMD5=$(generateMD5 "${paths[0]}")
    
    
    # md5_1=$(md5sum "${paths[0]}" | cut -d ' ' -f 1)
    
    # i = 1 because the first path is the reference one
    for ((i = 1; i < ${#paths[@]}; i++)); do
        path="${paths[$i]}"
        
        currentMD5=$(generateMD5 "$path")
        
        # Compare the MD5 checksums
        if [ "$refrenceMD5" == "$currentMD5" ]; then
            echo "Files $refrenceMD5 and $currentMD5 are identical"
        else
            echo "Files $refrenceMD5 and $currentMD5 are different"
        fi
        
    done
    
    
    
}