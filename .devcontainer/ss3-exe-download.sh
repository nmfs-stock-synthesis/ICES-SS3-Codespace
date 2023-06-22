wget -O ss https://github.com/nmfs-stock-synthesis/stock-synthesis/releases/latest/download/ss_linux
sudo chmod a+x ss

wget https://github.com/nmfs-stock-synthesis/user-examples/archive/refs/heads/main.zip
sudo unzip main.zip
sudo chmod a+x user-examples-main
sudo mv user-examples-main/model_files model_files
sudo chmod 777 model_files
sudo rm -r -f user-examples-main
sudo rm -r -f main.zip
find model_files/* -type d -exec cp ss {} \;