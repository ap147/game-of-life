# Game-of-Life

![](https://media.giphy.com/media/7FgnEVdDRO4uU62QaA/giphy.gif)

Implement conways game of life in CUDA 
- https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life

Acceptance criteria:

- Makefile (or CMake)
- Wraps around
- Passes cuda-memcheck
- Full data parallelism
- No memcpy in the main loop (except for printing purpose)
- Printing each iteration is optional
- Variable array sizes (from 1 to more than 1024)
