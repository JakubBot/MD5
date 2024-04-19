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
    
    for path in "${paths[@]}"; do
        echo "$path" >> "raport.txt"
    done
    
    echo "" >> "raport.txt"
    echo "Pliki bez potrzebnych uprawnien read(ominiete w porownaniach):" >> "raport.txt"
    
    inaccessible_paths_length=${#inaccessible_paths[@]}
    
    if [ $inaccessible_paths_length -eq 0 ]; then
        echo "Brak" >> "raport.txt"
    else
        for path in "$inaccessible_paths"; do
            echo "$path" >> "raport.txt"
        done
        echo "Suma: $inaccessible_paths_length" >> "raport.txt"
    fi
    
    echo "" >> "raport.txt"
    echo "Pliki różniące się od pliku referencyjnego:" >> "raport.txt"
    
    diffrentFilesLength=${#diffrentFiles[@]}
    
    if [ $diffrentFilesLength -eq 0 ]; then
        echo "Brak" >> "raport.txt"
    else
        for path in "$diffrentFiles"; do
            echo "$path" >> "raport.txt"
        done
        echo "Suma: $diffrentFilesLength" >> "raport.txt"
        
    fi
    
    echo "" >> "raport.txt"
    echo "Plik referencyjny(glowny):" >> "raport.txt"
    echo "$refrenceFile" >> "raport.txt"
    
    echo "" >> "raport.txt"
    echo "Raport wygenerowany: $(date)" >> "raport.txt"
}

function generateFileChangeRaport {
    echo ""
}