scriptencoding utf-8

if exists('g:loaded_vim_webpage')
  finish
endif
let g:loaded_vim_webpage = v:true

" Example:
"  let g:webpage_source = #{
"    \ weblio: 'http://ejje.weblio.jp/content/%s',
"  \ }
let g:webpage_source = get(g:, 'webpage_source', #{})

" Example:
" :WebpageShow weblio a word I don't know
command! -bar -nargs=+ WebpageShow call webpage#open(<f-args>)
