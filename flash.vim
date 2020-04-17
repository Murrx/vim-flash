let g:result = []
function! LoadCards()
    let cards_dir = 'cards'
    let sub_dirs = systemlist('ls '.cards_dir)

    for dir in sub_dirs
        let card_dir = cards_dir.'/'.dir
        let card_string = join(readfile(card_dir.'/card.json'))
        let card_data = json_decode(card_string)

        let objective_path = card_dir.'/'.card_data.objective.uri
        let input_path =  card_data.input.uri  " note: this uses other pathing than other files. Needs fixing
        let output_path =  card_dir.'/'.card_data.output.uri
        let solution_path =  card_dir.'/'.card_data.solution.uri

        call add(g:result, {'objective_path': objective_path, 'input_path': input_path, 'output_path': output_path, 'solution_path': solution_path})
    endfor
endfunction

function! InitEditor(card)
   " Setup front of card
   set nomodifiable
   execute 'view' a:card.objective_path
   vsplit
   vertical res 35
   wincmd l
   execute 'edit' a:card.input_path
   set modifiable
   execute 'silent belowright diffpatch' a:card.output_path
   
   " Setup back of card
   tabedit
   execute 'view' a:card.solution_path
   set nomodifiable
   
   " Return view to front of card
   tabp
   wincmd k
endfunction

if len(g:result) == 0
    call LoadCards()
endif

call InitEditor(g:result[0])
