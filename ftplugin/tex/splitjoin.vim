let b:splitjoin_split_callbacks = [
            \ 'sj#tex#SplitArgs',
            \ 'sj#tex#SplitBlock',
            \ 'sj#tex#SplitCommand',
            \ ]

let b:splitjoin_join_callbacks = [
            \ 'sj#tex#JoinArgs',
            \ 'sj#tex#JoinBlock',
            \ 'sj#tex#JoinCommand',
            \ ]
