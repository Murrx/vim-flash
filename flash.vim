let g:result = []
function! LoadCards()
    let cards_dir = 'cards'
    let sub_dirs = systemlist('ls '.cards_dir)

    for dir in sub_dirs
        let card_dir = cards_dir.'/'.dir
        let obj = card_dir.'/'.'front/objective.txt'
        let input = card_dir.'/'.'front/input.vim'
        let patch = card_dir.'/'.'front/patch'
        let solution = card_dir.'/'.'back/solution.txt'
        call add(g:result, {'obj': obj, 'input': input, 'patch': patch, 'solution': solution})
    endfor
endfunction

function! InitEditor(card)
   " Setup front of card
   set nomodifiable
   execute 'view' a:card.obj
   vsplit
   vertical res 35
   wincmd l
   execute 'source' a:card.input
   execute 'edit' g:source_file
   set modifiable
   execute 'silent belowright diffpatch' a:card.patch
   
   " Setup back of card
   tabedit
   execute 'view' a:card.solution
   set nomodifiable
   
   " Return view to front of card
   tabp
   wincmd k
endfunction

if len(g:result) == 0
    call LoadCards()
endif

call InitEditor(g:result[1])
