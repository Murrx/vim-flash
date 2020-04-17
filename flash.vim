let g:result = []
function! LoadCards()
    let cards_dir = 'cards'
    let sub_dirs = systemlist('ls '.cards_dir)

    for dir in sub_dirs
        let card_dir = cards_dir.'/'.dir
        let card_string = join(readfile(card_dir.'/card.json'))
        let card_data = json_decode(card_string)
        call add(g:result, {'card_data': card_data, 'dir': card_dir})
    endfor
endfunction

function! InitEditor(card)
   " Setup front of card
   set nomodifiable
   execute 'view' a:card.dir.'/'.a:card.card_data.objective.uri
   vsplit
   vertical res 35
   wincmd l
   execute 'edit' a:card.card_data.input.uri
   set modifiable
   execute 'silent belowright diffpatch' a:card.dir.'/'.a:card.card_data.output.uri
   
   " Setup back of card
   tabedit
   execute 'view' a:card.dir.'/'.a:card.card_data.solution.uri
   set nomodifiable
   
   " Return view to front of card
   tabp
   wincmd k
endfunction

if len(g:result) == 0
    call LoadCards()
endif

call InitEditor(g:result[0])
