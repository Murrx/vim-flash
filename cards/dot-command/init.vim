" Setup front of card
set nomodifiable
view front/objective.txt
vsplit
vertical res 35
wincmd l
edit front/input.js
silent belowright diffpatch front/patch
set modifiable

" Setup back of card
tabedit
args back/*
set nomodifiable

" Return view to front of card
tabp
