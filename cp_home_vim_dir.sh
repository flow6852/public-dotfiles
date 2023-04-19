#!/bin/bash

Vimdirs=("filetype.vim" "ftplugin" "snippets" "vsnip" "available")
Homedirs=("vimrc")
Nvimdirs=("init.vim")
OtherDirs=("")

Repository="flow6852/vim-neovim-test-env"

pwd="$(pwd)"

if [ "$(basename ${pwd})" != "$(basename ${Repository})" ]  && [ "$(git remote get-url origin | cut -f2 -d':')" != "${Repository}" ]
then
    echo "run only :: ./cp_home_vim_dir.sh"
    exit 1
fi

for i in ${Homedirs[@]}
do
    echo cp ${HOME}/.${i} ${i}
    cp ${HOME}/.${i} ${i}
done

rm -rf ./vim && mkdir -p ./vim
for i in ${Vimdirs[@]}
do
    echo cp -r ${HOME}/.vim/${i} ./vim/${i}
    cp -r ${HOME}/.vim/${i} ./vim/${i}
done


for i in ${Nvimdirs[@]}
do
    echo cp ${HOME}/.config/nvim/${i} ${i}
    cp ${HOME}/.config/nvim/${i} ${i}
done

# edit plugin lists in README.md FOR ME

echo cp README.tmp README.md
cp README.tmp README.md

grep 'Plug' vim/available/10-vim-plug-unix.vim | grep -v '" Plug' | sed "s/\( \)*Plug\( \)*'\([^']*\)'/\* https:\/\/github.com\/\3/g" >> README.md

sed -e 's/~\/Programs\/vim-plugins/flow6852/g' -i README.md README.md
sed -e 's/~\/Programs\/vim-plugins/flow6852/g' -i vim/available/10-vim-plug-unix.vim vim/available/10-vim-plug-unix.vim
sed -e 's/~\/Programs\/vim-plugins/flow6852/g' -i vim/available/10-vim-plug-win.vim vim/available/10-vim-plug-win.vim
