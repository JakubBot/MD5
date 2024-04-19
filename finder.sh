$fileName
$directory

function findFolder {
    if [ "$directory" = "." ]; then
        found_folder=$(pwd)
        elif [ "$directory" = "/" ]; then
        found_folder="/"
    else
        found_folder=$(find "$HOME" -type d -name "$directory" -print -quit)
        
        
        if [ -z "$found_folder" ]; then
            # echo "Folder \"$directory\" nie został znaleziony."
            zenity --info --text "Folder \"$directory\" nie został znaleziony."
            return 1
        fi
    fi
    
    echo "$found_folder"
}


function getFileName {
    fileName=$(zenity --entry --title="Podaj nazwe pliku" --text="Podaj nazwe pliku")
}

function getDirectory {
    # directory=$(zenity --file-selection --directory --title="Wybierz katalog")
    directory=$(zenity --entry --title="Podaj nazwe katalogu" --text="Podaj nazwe katalogu")
    
}

function findFile {
    # najpierw znajdz folder, potem z folderu szukaj plik
    getDirectory
    
    if [ -z "$directory" ]; then
        return
    fi
    
    getFileName

    if [ -z "$fileName" ]; then
        return
    fi

    
    found_folder=$(findFolder)
    
    if [ $? -eq 1 ]; then
        zenity --info --text "Nie znaleziono katalogu."
        return
    fi
    
    # -quit = zatrzymuje szukanie po znalezieniu pierwszego pliku
    find_query="find \"$found_folder\" -type f -name \"$fileName*\" -print -quit"
    
    wynik=$(eval "$find_query")
    
    
    #reset
    fileName=""
    directory=""
    
    echo "$wynik"
}

function handleFolderSearch {
    getDirectory

    if [ -z "$directory" ]; then
        return
    fi
    
    found_folder=$(findFolder)
    
    
    if [ $? -eq 1 ]; then
        zenity --info --text "Nie znaleziono katalogu."
        return
    fi
    
    directory=""
    
    echo "$found_folder"
}