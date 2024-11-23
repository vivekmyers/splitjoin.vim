let b:splitjoin_split_callbacks = [
            \ 'sj#tex#SplitBlock',
            \ 'sj#tex#SplitArgs',
            \ 'sj#tex#SplitCommand',
            \ ]

let b:splitjoin_join_callbacks = [
            \ 'sj#tex#JoinBlock',
            \ 'sj#tex#JoinCommand',
            \ 'sj#tex#JoinArgs',
            \ ]
