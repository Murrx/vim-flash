" Setup front of card
set nomodifiable
view front/objective.txt
vsplit
vertical res 35
wincmd l
edit front/input.js
set modifiable
silent belowright diffpatch front/patch

" Setup back of card
tabedit
args back/*
set nomodifiable

" Return view to front of card
tabp
