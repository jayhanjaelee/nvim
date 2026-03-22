-- cpp
local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  -- sdl2
  s('sdl2_init', {
    t({
      '#include <stdio.h>',
      '#include <SDL2/SDL.h>',
      '#include <SDL2/SDL_video.h>',
      '',
      'int main(int argc, char* argv[]) {',
      '    SDL_Window* window = NULL;',
      '',
      '    // SDL 초기화',
      '    if (SDL_Init(SDL_INIT_VIDEO) < 0) {',
      '        printf("SDL Initialization Fail: %s\\n", SDL_GetError());',
      '        return 1;',
      '    }',
      '',
      '    // 윈도우 창 생성',
      '    window = SDL_CreateWindow("',
    }),
    i(1, 'SDL2 Window'),
    t({
      '",',
      '        SDL_WINDOWPOS_UNDEFINED,',
      '        SDL_WINDOWPOS_UNDEFINED,',
      '        ',
    }),
    i(2, '640'),
    t(', '),
    i(3, '480'),
    t({
      ',',
      '        SDL_WINDOW_SHOWN);',
      '    if (!window) {',
      '        printf("Window Creation Fail: %s\\n", SDL_GetError());',
      '        SDL_Quit();',
      '        return 1;',
      '    }',
      '',
      '    // 윈도우 Foreground 로 설정',
      '    SDL_RaiseWindow(window);',
      '',
      '    // 메시지 루프',
      '    SDL_Event event;',
      '    int quit = 0;',
      '    while (!quit) {',
      '        while (SDL_PollEvent(&event)) {',
      '            if (event.type == SDL_QUIT) {',
      '                quit = 1;',
      '            }',
      '        }',
      '    }',
      '',
      '    // 종료',
      '    SDL_DestroyWindow(window);',
      '    SDL_Quit();',
      '    return 0;',
      '}',
    }),
  });
}
