return {
  "vim-test/vim-test",
  init = function()
    -- csms45(moodle) behat 시나리오는 도커 컨테이너 안에서만 돌아간다(DB host.docker.internal,
    -- behat_wwwroot가 컨테이너 내부망 전용 http://csms45). vim-test 기본 러너는
    -- "./vendor/bin/behat <호스트 절대경로>"를 호스트에서 직접 실행하므로 그대로 두면 항상 실패한다.
    -- test#transformation 훅으로 최종 커맨드를 docker exec로 감싸고, 호스트 경로를 컨테이너
    -- 경로(/var/www/html)로, 실행 파일을 behat.yml(behat init이 생성한 컨테이너 쪽 설정)을
    -- 가리키는 vendor/bin/behat로 바꿔친다. behat이 아닌 다른 러너(phpunit 등)는 그대로 통과.
    vim.cmd([[
      function! Csms45BehatTransform(cmd) abort
        if a:cmd !~# 'vendor/bin/behat'
          return a:cmd
        endif
        let l:cmd = a:cmd
        let l:cmd = substitute(l:cmd, '\V' . escape(getcwd(), '\'), '/var/www/html', 'g')
        let l:cmd = substitute(l:cmd, '\V./vendor/bin/behat',
              \ 'vendor/bin/behat --config /var/moodledata_behat/behatrun/behat/behat.yml', '')
        return 'docker exec -u www-data csms45 ' . l:cmd
      endfunction
      let g:test#custom_transformations = {'csms45_behat': function('Csms45BehatTransform')}
      let g:test#transformation = 'csms45_behat'
    ]])
  end,
  keys = {
    { "<leader>tn", ":TestNearest<CR>", desc = "Test nearest" },
    { "<leader>tf", ":TestFile<CR>", desc = "Test file" },
    { "<leader>ts", ":TestSuite<CR>", desc = "Test suite" },
    { "<leader>tl", ":TestLast<CR>", desc = "Test last" },
    { "<leader>tv", ":TestVisit<CR>", desc = "Test visit" },
  },
}
