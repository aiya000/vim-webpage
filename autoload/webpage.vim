scriptversion 3
scriptencoding utf-8

let s:V = vital#webpage#new()

let s:HTTP = s:V.import('Web.HTTP')
let s:Job = s:V.import('System.Job')

function webpage#open(...) abort
  const cmd = ['w3m', '-dump', s:get_source_url(a:000)]
  echo 'vim-webpage: loading...'

  call s:Job.start(cmd, #{
    \ stdout: [''],
    \ stderr: [''],
    \ on_stdout: function('s:aggregate_stdout'),
    \ on_stderr: function('s:aggregate_stderr'),
    \ on_exit: function('s:show'),
  \ })
endfunction

function s:get_source_url(data) abort
  const name = a:data[0]
  const abstract_url = g:webpage_source[name]
  const params = s:HTTP.encodeURI(join(a:data[1:]))
  return printf(abstract_url, params)
endfunction

function s:aggregate_stdout(data) abort dict
  let self.stdout[-1] ..= a:data[0]
  call extend(self.stdout, a:data[1:])
endfunction

function s:aggregate_stderr(data) abort dict
  let self.stderr[-1] ..= a:data[0]
  call extend(self.stderr, a:data[1:])
endfunction

function s:show(data) abort dict
  echo 'vim-webpage: done!'

  if self.stderr !=# ['']
    echomsg 'vim-webpage:' 'Errors occured:' self.stderr
  endif

  call popup_create(self.stdout, #{
    \ border: [],
    \ padding: [],
  \ })
endfunction
