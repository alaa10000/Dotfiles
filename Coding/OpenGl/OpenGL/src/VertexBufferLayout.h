#pragma once

#include <vector>

struct VertexBufferElement
{

};

class VertexBufferLayout
{
private:
  std::vector<VertexBufferElement> m_Elements;
public:
  VertexBufferLayout();

};
