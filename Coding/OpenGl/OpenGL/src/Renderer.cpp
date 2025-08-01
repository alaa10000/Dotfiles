#include "Renderer.h"

#include <iostream>

#define ASSERT(x) if (!(x)) __has_builtin(__builtin_debugtrap);
#define GLCall(x) GLClearError();\
  x;\
  ASSERT(GLLogCall(#x, __FILE__, __LINE__))

void GLClearError()
{
  while (glGetError() != GL_NO_ERROR);
}

bool GLLogCall(const char* function, const char* file, int line)
{
  while (GLenum error = glGetError())
  {
    std::cout << "[OpenGL Error] (" << error << ")" << function << " " << file << ";" << line << std::endl;
    return false;
  }
  return true;
}

