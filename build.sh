if [ "$2" = "" ]
then
    LOVE_PATH = "C:\Program Files\LOVE\love.exe"
else
    LOVE_PATH = $2
fi

if [ "windows" = "$1" ]
then
    echo "Building for Windows"
    mkdir build
    mkdir build/windows
    zip -r build/app.zip src/*
    cat $LOVE_PATH/love.exe app.zip > build/windows/App.exe
    cp $LOVE_PATH/*.dll build/windows/
elif [ "linux" = "$1" ]
then
    echo "Building for Linux"
    mkdir build
    mkdir build/linux
    zip -r build/app.zip src/*
    cat /usr/bin/love app.zip > build/linux/App
    mkdir build/linux/assets
    cp -r assets/* build/linux/assets/
    chmod a+x ./build/linux/App
elif [ "clean" = "$1" ]
then
    echo "Cleaning"
    rm -rf build
    rm -rf app.zip
else
    echo "Usage: ./build.sh [windows|linux|clean]"
fi