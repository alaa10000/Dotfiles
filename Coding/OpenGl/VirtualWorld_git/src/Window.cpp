#include "Window.hpp"


Window::Window() {
  glfwInit();
  glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
  glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
  glfwWindowHint(GLFW_RESIZABLE, GL_FALSE);

  Window::window = glfwCreateWindow(1100, 700, "Window", NULL, NULL);
  glfwMakeContextCurrent(Window::window);
}

Window::~Window() {
  glfwTerminate();
}
