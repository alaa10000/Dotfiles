cmake_minimum_required(VERSION 3.15)
project(project)
cmake_policy(SET CMP0072 NEW)

find_package(OpenGL REQUIRED)
find_package(GLEW REQUIRED)

set(CMAKE_C_STANDARD 11) # Requires C11 standard

add_executable(${PROJECT_NAME} 
  src/Renderer.cpp
  src/Window.cpp
  src/Shader.cpp
  src/Camera.cpp
  src/stb_image.cpp)

target_link_libraries(${PROJECT_NAME} OpenGL::GL GLEW::GLEW glfw imgui)
