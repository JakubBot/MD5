source constants.sh
source utils.sh

#variable that contains every user path
allPaths=()
#variable that contains every user directory
allDirectories=()
# all readable paths
paths=()
# all readable directories
directories=()
# diffrent generated md5 on files
diffrentFiles=()
# no read permission file paths
inaccessible_paths=()
# no read permission dirs
inaccessible_directories=()
# no read permission file paths when comparing directories
inaccessible_paths_in_dirs=()
# diffrent generated md5 on directories
diffrentDirectories=()
# diffrent files in directories
diffrentFilesInDirs=()
# not existing files in directories
notExistingFilesInDirs=()


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

function generateMD5ForTar {
    # Get the MD5 checksum of the tar file
    
    # Tworzenie tymczasowego folderu
    temp_folder=$(mktemp -d)
    
    local sourceTar="$1"
    # Wypakowywanie archiwum do tymczasowego folderu
    tar xf $sourceTar -C "$temp_folder"
    
    # Obliczanie sumy kontrolnej MD5 dla tymczasowego folderu
    wynik=$(generateMD5ForDirectory "$temp_folder")
    
    # Usuwanie tymczasowego folderu
    rm -rf "$temp_folder"
    
    echo "$wynik"
}




# first argument is the file paths(array)
function compareFiles {
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
        zenity --info --text "Podano za mało plików, ktore mozna porownac" --width=$universalInfoWidth --height=200
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
    allPaths=()
    inaccessible_paths=()
    diffrentFiles=()
}

function compareDirectories {
    # /Users/jakubbot/Desktop/MD5/test
    allDirectories=("$@")
    
    for dir in "${allDirectories[@]}"; do
        if [ -r "$dir" ]; then
            directories+=("$dir")
        else
            inaccessible_directories+=("$dir")
        fi
    done
    
    directoriesSize=${#directories[@]}
    
    if [ $directoriesSize -lt 2 ]; then
        zenity --info --text "Podano za mało folderów, ktore mozna porownac" --width=$universalInfoWidth --height=200
        return
    fi
    
    refrenceDir="${directories[0]}"
    
    refrenceDirMD5=$(generateMD5ForDirectory "$refrenceDir")
    
    local areDirectoriesEqual=$TRUE
    # i = 1 because the first path is the reference one
    for ((i = 1; i < ${#directories[@]}; i++)); do
        dir="${directories[$i]}"
        
        currentDirMD5=$(generateMD5ForDirectory "$dir")
        
        # Compare the MD5 checksums
        if [ "$refrenceDirMD5" == "$currentDirMD5" ]; then
            continue
            
        else
            areDirectoriesEqual=$FALSE
            diffrentDirectories+=("$dir")
        fi
    done
    
    if [ $areDirectoriesEqual -eq $TRUE ]; then
        zenity --info --text "Foldery sa takie same \n\nRaport zostal wygenerowany w pliku raport.txt" --width=$universalInfoWidth --height=200
    else
        zenity --info --text "Foldery nie sa takie same \n\nRaport zostal wygenerowany w pliku raport.txt" --width=$universalInfoWidth --height=200
    fi
    
    generateDirectoryRaport $refrenceDir
    
    # reset
    allDirectories=()
    directories=()
    diffrentDirectories=()
    inaccessible_directories=()
    diffrentFilesInDirs=()
    notExistingFilesInDirs=()
}

function resetVars {
    allPaths=()
    allDirectories=()
    paths=()
    directories=()
    diffrentFiles=()
    inaccessible_paths=()
    inaccessible_directories=()
    inaccessible_paths_in_dirs=()
    diffrentDirectories=()
    diffrentFilesInDirs=()
    notExistingFilesInDirs=()
}

function getDiffrentFilesInDirs {
    # for two directories, return an array of files that are different
    # $1 - first directory
    # $2 - second directory
    local firstDir="$1"
    local secondDir="$2"
    
    # get all files from the first directory
    local firstDirFiles=($(find "$firstDir" -type f))
    # get all files from the second directory
    local secondDirFiles=($(find "$secondDir" -type f))
    
    
    for file in "${firstDirFiles[@]}"; do
        # get the file name
        local fileName=$(basename "$file")
        # get the file path in the second directory
        # check if it has read permission
        
        if [ ! -r "$file" ]; then
            continue
            
        fi
        
        local secondFilePath=$(find "$secondDir" -type f -name "$fileName" -print -quit)
        
        if [ ! -r "$secondFilePath" ]; then
            inaccessible_paths_in_dirs+=("$secondFilePath")
            continue
        fi
        
        # if the file does not exist in the second directory
        if [ -z "$secondFilePath" ]; then
            notExistingFilesInDirs+=("$file")
        else
            # get the md5 checksum of the file in the first directory
            local firstFileMD5=$(generateMD5 "$file")
            # get the md5 checksum of the file in the second directory
            local secondFileMD5=$(generateMD5 "$secondFilePath")
            # if the md5 checksums are diffrent
            if [ "$firstFileMD5" != "$secondFileMD5" ]; then
                diffrentFilesInDirs+=("$file")
            fi
        fi
    done
    
    
    
}