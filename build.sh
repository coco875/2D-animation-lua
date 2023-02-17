
if [ "windows" = "$1" ]
then
    echo "Building for Windows"
    mkdir build
    mkdir build/windows
    zip -r app.zip ./ -x build/* -x love/* -x *.sh -x .git* -x *.bat
    cat love/love.exe app.zip > build/windows/App.exe
    cp love/*.dll build/windows/
elif [ "linux" = "$1" ]
then
    echo "Building for Linux"
    mkdir build
    mkdir build/linux
    zip -r app.zip ./ -x build/* -x love/* -x *.sh -x .git* -x *.bat -x assets/*
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