let g:result = []
let g:card_index = 0

function LoadCards()
    let package_dir = 'card-packs/practical-vim/'
    let cards_dir = package_dir . 'cards/'
    let sub_dirs = systemlist('ls '.cards_dir)

    for dir in sub_dirs
        let card_dir = cards_dir.dir
        let json_string = join(readfile(card_dir.'/card.json'))
        let card_data = json_decode(json_string)

        let objective_path = card_dir.'/'.card_data.objective.uri
        let input_path =  card_dir.'/'.card_data.input.uri 
        let output_path =  card_dir.'/'.card_data.output.uri
        let solution_path =  card_dir.'/'.card_data.solution.uri

        call add(g:result, {'objective_path': objective_path, 'input_path': input_path, 'output_path': output_path, 'solution_path': solution_path})
    endfor
endfunction

function InitEditor(card)
   " Setup front of card
   execute 'view' a:card.objective_path
   call MakeScratchBuffer()
   vsplit
   vertical res 35
   wincmd l

   execute 'edit' a:card.input_path
   call MakeScratchBuffer()

   execute 'silent belowright diffpatch' a:card.output_path
   call MakeScratchBuffer()
   
   " Setup back of card
   tabedit
   execute 'view' a:card.solution_path
   call MakeScratchBuffer()
   
   " Return view to front of card
   tabp
   wincmd k
endfunction

function MakeScratchBuffer()
   setlocal buftype=nofile
   setlocal bufhidden=hide
   setlocal noswapfile
endfunction

function ResetEditor()
    silent only
    silent tabonly
    %bd  " delete all buffers. Need to find a more elegant way to reset editor state
endfunction

if len(g:result) == 0
    call LoadCards()
endif

function LoadNext()
    call LoadCards()  " Todo: find a more elegant way to do this
    call ResetEditor()

    let index = g:card_index % len(g:result)
    call InitEditor(g:result[index])
    let g:card_index = g:card_index + 1
endfunction

command FlashVim call LoadNext()
