" Setup front of card
set nomodifiable
args front/*
vsplit
vertical res 35
wincmd l
next
split
next
set modifiable

" Setup back of card
tabedit
args back/*
set nomodifiable

" Return view to front of card
tabp
