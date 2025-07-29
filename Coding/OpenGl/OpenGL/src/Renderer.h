#pragma once

#include <GL/glew.h>

#define ASSERT(x) if (!(x)) __has_builtin(__builtin_debugtrap);
#define GLCall(x) GLClearError();\
  x;\
  ASSERT(GLLogCall(#x, __FILE__, __LINE__))

void GLClearError();
bool GLLogCall(const char* function, const char* file, int line);

