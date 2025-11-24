#ifndef WINDOW_HPP
#define WINDOW_HPP

#include <GLFW/glfw3.h>

class Window
{
public:
  GLFWwindow *window; 

  Window();
  ~Window();
};
#endif
