#shader vertex
#version 330 core

layout(location = 0) in vec4 position;
layout(location = 1) in vec3 vertexColor;

out vec3 theColor;

void main()
{
  gl_Position = position;
  theColor = vertexColor;
};

#shader fragment
#version 330 core

out vec4 color;
in vec3 theColor;

uniform vec4 u_Color;

void main()
{
  color = u_Color;
};
