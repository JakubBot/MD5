source constants.sh

# dont add .sh because it creates some kind of loop and throws segmentation fault
source compareMD5

function isNumber {
    re='^[0-9]+$'
    if ! [[ $1 =~ $re ]] ; then
        echo $FALSE
    else
        echo $TRUE
    fi
}

# arguments
# 1 - $refrenceFile path
function generateFileRaport {
    local refrenceFile="$1"
    
    echo "Przeszukane pliki:" > "raport.txt"
    
    for path in "${allPaths[@]}"; do
        echo " - $path" >> "raport.txt"
    done
    
    echo "" >> "raport.txt"
    echo "Plik referencyjny(glowny):" >> "raport.txt"
    echo " - $refrenceFile" >> "raport.txt"
    
    echo "" >> "raport.txt"
    echo "Pliki różniące się od pliku referencyjnego:" >> "raport.txt"
    
    diffrentFilesLength=${#diffrentFiles[@]}
    
    if [ $diffrentFilesLength -eq 0 ]; then
        echo "Brak" >> "raport.txt"
    else
        for path in "$diffrentFiles"; do
            echo " - $path" >> "raport.txt"
        done
        echo "Suma: $diffrentFilesLength" >> "raport.txt"
        
    fi
    
    echo "" >> "raport.txt"
    echo "Pliki nie posiadajace potrzebnych uprawnien read(ominiete w porownaniach):" >> "raport.txt"
    
    inaccessible_paths_length=${#inaccessible_paths[@]}
    
    if [ $inaccessible_paths_length -eq 0 ]; then
        echo "Brak" >> "raport.txt"
    else
        for path in "$inaccessible_paths"; do
            echo " - $path" >> "raport.txt"
        done
        echo "Suma: $inaccessible_paths_length" >> "raport.txt"
    fi
    
    echo "" >> "raport.txt"
    echo "Raport wygenerowany: $(date)" >> "raport.txt"
}

function generateDirectoryRaport {
    local refrenceDir="$1"
    
    echo "Przeszukane foldery:" > "raport.txt"
    
    for path in "${allDirectories[@]}"; do
        echo " - $path" >> "raport.txt"
    done
    
    echo "" >> "raport.txt"
    echo "Folder referencyjny(glowny):" >> "raport.txt"
    echo " - $refrenceDir" >> "raport.txt"
    
    echo "" >> "raport.txt"
    echo "Foldery różniące się od folderu referencyjnego:" >> "raport.txt"
    
    diffrentDirectoriesLength=${#diffrentDirectories[@]}
    
    if [ $diffrentDirectoriesLength -eq 0 ]; then
        echo "Brak" >> "raport.txt"
    else
        for path in "$diffrentDirectories"; do
            echo " - $path na podstawie:" >> "raport.txt"
            # show why folders are not equal based on
            # if files are different / not existing / no readable
            
            getDiffrentFilesInDirs "$refrenceDir" "$path"
            
            diffrentFilesInDirsLength=${#diffrentFilesInDirs[@]}
            notExistingFilesInDirsLength=${#notExistingFilesInDirs[@]}
            inaccessible_paths_in_dirs_length=${#inaccessible_paths_in_dirs[@]}
            
            if [ $diffrentFilesInDirsLength -gt 0 ]; then
                echo "      Pliki różniące się:" >> "raport.txt"
                for file in "${diffrentFilesInDirs[@]}"; do
                    echo "       $file" >> "raport.txt"
                done
            fi
            
            if [ $notExistingFilesInDirsLength -gt 0 ]; then
                echo "      Pliki nie istniejące:" >> "raport.txt"
                for file in "${notExistingFilesInDirs[@]}"; do
                    echo "       $file" >> "raport.txt"
                done
            fi
            
            if [ $inaccessible_paths_in_dirs_length -gt 0 ]; then
                echo "      Pliki nie posiadajace potrzebnych uprawnien read(ominiete w porownaniach):" >> "raport.txt"
                for path in "${inaccessible_paths_in_dirs[@]}"; do
                    echo "       $path" >> "raport.txt"
                done
            fi
            
        done
        
        echo "" >> "raport.txt"
        echo "Suma: $diffrentDirectoriesLength" >> "raport.txt"
        
    fi
    
    echo "" >> "raport.txt"
    echo "Foldery nie posiadajace potrzebnych uprawnien read(ominiete w porownaniach):" >> "raport.txt"
    
    inaccessible_directories_length=${#inaccessible_directories[@]}
    
    if [ $inaccessible_directories_length -eq 0 ]; then
        echo "Brak" >> "raport.txt"
    else
        for path in "$inaccessible_directories"; do
            echo " - $path" >> "raport.txt"
        done
        echo "" >> "raport.txt"
        echo "Suma: $inaccessible_directories_length" >> "raport.txt"
    fi
    
    echo "" >> "raport.txt"
    echo "Raport wygenerowany: $(date)" >> "raport.txt"
    
}