#! /bin/bash
set -e

#=========================================
# Create Conda environment
#-----------------------------------------
read -e -p "Enter your conda command (conda/mamba/micromamba): " cmd
echo "This set up will use \`$cmd\`. (hit enter to continue)"
read
read -e -p "Enter environment location path [./.lsdc]: " env_path
env_path=${env_path:-'./.lsdc'}
echo "Creating environment at \`$env_path\`. (hit enter to continue)"
read
"$cmd" env create -p $env_path --file=env.yml
if [ "$cmd" ==  "micromamba" ]; then
    eval "$($cmd shell hook -s bash)"
else
    eval "$($cmd shell.bash hook)"
fi
$cmd activate $env_path

#========================================
# Install Pip dependencies
#----------------------------------------
echo ">>> Installing pip dependencies"
pip install --upgrade pip
pip install -r requirements.txt
nbstripout --install

#========================================
# Setup Git submodules
#----------------------------------------
echo ">>> Setting up git submodules" 
git submodule init
git submodule update

#========================================
# Download Kaggle data
#----------------------------------------
kaggle competitions download -c rsna-2024-lumbar-spine-degenerative-classification
unzip rsna-2024-lumbar-spine-degenerative-classification.zip -d data
rm -rf rsna-2024-lumbar-spine-degenerative-classification.zip

echo ">>> Done with environment set up"
echo ">>> Activate with the following command"
echo "          $cmd activate $env_path"
