#pragma once
#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>

enum Camera_Movement {
    FORWARD,
    BACKWARD,
    LEFT,
    RIGHT
};

class Camera{
public:
  bool firstMouse = true;
  float xpos, ypos;
  float lastX =  1100.0f / 2.0;
  float lastY =  700.0 / 2.0;
  float cameraSpeed = 8.0f;
  float sensitivity = 0.15f;
  float yaw   = -90.0f;
  float pitch =  0.0f;
  glm::vec3 cameraPos   = glm::vec3(0.0f, 0.0f,  3.0f);
  glm::vec3 cameraFront = glm::vec3(0.0f, 0.0f, -1.0f);
  glm::vec3 cameraUp    = glm::vec3(0.0f, 1.0f,  0.0f);

  glm::mat4 GetViewMatrix();
  void cursorPos();
  void matrix(float xoffset, float yoffset);
  void mouse(GLFWwindow* window);
  void keyboard(GLFWwindow* window, float deltaTime);
  void input(GLFWwindow* window, float deltaTime);
};
