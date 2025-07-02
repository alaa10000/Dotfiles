#include <GL/glew.h>
#include <GLFW/glfw3.h>

#include <cassert>
#include <iostream>
#include <fstream>
#include <sstream>

#include "Renderer.h"

#include "VertexBuffer.h"
#include "IndexBuffer.h"

using namespace std;

struct ShaderProgramSource
{
  string VertexSource;
  string FragmentSource;
};

static ShaderProgramSource ParseShader(const std::string& filepath)
{
  fstream stream(filepath);

  enum class ShaderType
  {
    NONE = -1, VERTEX = 0, FRAGMENT = 1
  };


  string line;
  stringstream ss[2];
  ShaderType type = ShaderType::NONE;
  while (getline(stream, line))
  {
    if (line.find("#shader") != string::npos)
    {
      if (line.find("vertex") != string::npos)
        type = ShaderType::VERTEX;
      else if (line.find("fragment") != string::npos)
        type = ShaderType::FRAGMENT;

    }
    else 
    {
      ss[(int)type] << line << "\n";
    
    }
  }
  return{ss[0].str(), ss[1].str()};
}


GLuint compileShader(GLuint type, const std::string& source)
{
  GLuint id = glCreateShader(type);
  const char* src = source.c_str();
  glShaderSource(id, 1, &src, 0);
  glCompileShader(id);

  int result;
  glGetShaderiv(id, GL_COMPILE_STATUS, &result);
  if (result == GL_FALSE)
  {
    int length;
    glGetShaderiv(id, GL_INFO_LOG_LENGTH, &length);
    char* message = new char[length];
    glGetShaderInfoLog(id, length, &length, message);
    cout << "Failed to compile " << (type == GL_VERTEX_SHADER ? "vertex" : "fragment") << " shader!" << endl;
    cout << message << endl;
    glDeleteShader(id);
    return 0;
  }

  return id;
}

GLuint createShader(const std::string& vertexShader, const std::string& fragmentShader)
{
  GLuint program = glCreateProgram();
  GLuint vs = compileShader(GL_VERTEX_SHADER, vertexShader);
  GLuint fs = compileShader(GL_FRAGMENT_SHADER, fragmentShader);

  glAttachShader(program, vs);
  glAttachShader(program, fs);
  glLinkProgram(program);
  glValidateProgram(program);

  glDeleteShader(vs);
  glDeleteShader(fs);

  return program;
}

void framebuffer_size_callback(GLFWwindow* window, int width, int height)
{
    glViewport(0, 0, width, height);
}  

int main()
{
  GLFWwindow* window;

  glfwInit(); 



  window = glfwCreateWindow(300, 300, "ZMMR", NULL, NULL);
  if (!window)
  {
    glfwTerminate();
    return -1;
  }
  glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);

  glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
  glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);


  glfwMakeContextCurrent(window);

  glfwSwapInterval(1);

  glewExperimental = GL_TRUE;

  if (glewInit() != GLEW_OK)
    return 1;

  //cout << glGetString(GL_VERSION);

  float positions[] = {
    -0.5f, -0.5f,
    0.0f, 0.0f, 1.0f,
    0.5f, -0.5f,
    1.0f, 0.0f, 0.0f,
    0.5f, 0.5f,
    0.0f, 1.0f, 0.0f,
    -0.5f, 0.5f,
    1.0f, 0.0f, 0.0f,
  };

  GLuint indices [] = {0,1,2,  2,3,0};

  GLuint vao;
  glGenVertexArrays(1, &vao);
  glBindVertexArray(vao);


  VertexBuffer vbo(positions, sizeof(positions));

  glEnableVertexAttribArray(0);
  glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, sizeof(float) * 5, 0); 
  glEnableVertexAttribArray(1);
  glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 5, (char*)(sizeof(float) * 2)); 

  IndexBuffer ibo(indices, sizeof(indices));

  ShaderProgramSource source = ParseShader("../res/Basic.shader");

  GLuint shader = createShader(source.VertexSource, source.FragmentSource);

  int location = glGetUniformLocation(shader, "u_Color");
  ASSERT(location != -1);
  glUniform4f(location, 0.2f, 0.3f, 0.8f, 1.0f);

  glBindBuffer(GL_ARRAY_BUFFER, 0);
  glBindVertexArray(0);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);

  float r = 0.0f;
  float increment = 0.05f;


  while(!glfwWindowShouldClose(window))
  {
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);

    glUseProgram(shader);
    glUniform4f(location, r, 0.3f, 0.8f, 1.0f);

    glBindVertexArray(vao);
    GLCall(glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, nullptr));

    if (r > 1.0f)
      increment = -0.05f;
    else if (r < 0.0f)
      increment = 0.05f;

    r += increment;


    glfwSwapBuffers(window);
    glfwPollEvents();    
  }

  glDeleteProgram(shader);

  glfwTerminate();
  return 0;
}
