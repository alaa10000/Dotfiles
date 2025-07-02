#include <raylib.h>

int main ()
{

  InitWindow(600, 350, "3D");
  SetTargetFPS(60);

  Camera3D camera = { 0 };
  camera.position = (Vector3){ 0.0f, 5.0f, 5.0f };
  camera.target = (Vector3){ 0.0f, 0.0f, 0.0f }; 
  camera.up = (Vector3){ 0.0f, 1.0f, 0.0f }; 
  camera.fovy = 45.0f;
  camera.projection = CAMERA_PERSPECTIVE;

  while (!WindowShouldClose())
  {
    ClearBackground(WHITE);
    BeginDrawing();
    BeginMode3D(camera);
    
    DrawGrid(10, 0.5);


    EndMode3D();
    EndDrawing();
  }

  CloseWindow();
  return 0;
}
