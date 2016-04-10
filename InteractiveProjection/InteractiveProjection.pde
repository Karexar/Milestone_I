
void settings() {
    size(500,500,P3D);
}
    
void setup() {
    noStroke();
}
    
float scale = 1.0;
float rotationX = 0.0;
float rotationY = 0.0;
    
void draw() {  
  background(255, 255, 255);
  
  My3DPoint eye = new My3DPoint(0, 0, -5000);
  My3DPoint origin = new My3DPoint(0, 0, 0);
  My3DBox input3DBox = new My3DBox(origin, 100, 150, 300);
  
  float[][] transform = scaleMatrix(scale, scale, scale);
  input3DBox = transformBox(input3DBox, transform);
  float[][] transform2 = rotateXMatrix(rotationX);
  input3DBox = transformBox(input3DBox, transform2);
  float[][] transform3 = rotateYMatrix(rotationY);
  input3DBox = transformBox(input3DBox, transform3);
  float[][] transform4 = translationMatrix(250, 250, 0);
  input3DBox = transformBox(input3DBox, transform4);
  projectBox(eye, input3DBox).render();
}


My2DBox projectBox (My3DPoint eye, My3DBox box) {
  My2DPoint[] points = new My2DPoint[box.p.length];
  for (int i = 0 ; i < points.length ; ++i)
  {
    points[i] = projectPoint(eye, box.p[i]);
  }
  return new My2DBox(points);
}

My2DPoint projectPoint(My3DPoint eye, My3DPoint p) {
  float x = -(p.x - eye.x)/(p.z - eye.z) * eye.z;
  float y = -(p.y - eye.y)/(p.z - eye.z) * eye.z;
  return new My2DPoint(x, y);
}

// Step 1 - Homogeneous Representation

float[] homogeneous3DPoint (My3DPoint p) {
  float[] result = {p.x, p.y, p.z , 1};
  return result;
}

// Step 2 - Transformation Matrices


float[][] rotateXMatrix(float angle) {
  return(new float[][] {{1, 0 , 0 , 0},
                        {0, cos(angle), sin(angle) , 0},
                        {0, -sin(angle) , cos(angle) , 0},
                        {0, 0 , 0 , 1}});
}
float[][] rotateYMatrix(float angle) { 
  return(new float[][] {{cos(angle), 0 , sin(angle) , 0},
                        {0, 1, 0, 0},
                        {-sin(angle), 0, cos(angle), 0},
                        {0, 0 , 0 , 1}});
}
float[][] rotateZMatrix(float angle) { 
  return(new float[][] {{cos(angle), -sin(angle), 0 , 0},
                        {sin(angle), cos(angle) , 0, 0},
                        {0, 0, 1, 0},
                        {0, 0, 0, 1}});
}
float[][] scaleMatrix(float x, float y, float z) { 
  return(new float[][] {{x, 0, 0, 0},
                        {0, y, 0, 0},
                        {0, 0, z, 0},
                        {0, 0, 0, 1}});
}
float[][] translationMatrix(float x, float y, float z) { 
  return(new float[][] {{1, 0, 0, x},
                        {0, 1, 0, y},
                        {0, 0, 1, z},
                        {0, 0, 0, 1}});
}

// Step 3 - Matrix Product

float[] matrixProduct(float[][] a, float[] b) { 
  float res[] = {0.0, 0.0, 0.0, 0.0};
  for(int i = 0; i < 4 ; ++i)
    for(int j = 0 ; j < 4 ; ++j)
      res[i] += a[i][j] * b[j];
  return res;
}

My3DBox transformBox(My3DBox box, float[][] transformMatrix) {
  My3DPoint[] p = new My3DPoint[box.p.length];
  for (int i = 0 ; i < box.p.length ; ++i)
    p[i] = euclidian3DPoint(matrixProduct(transformMatrix, homogeneous3DPoint(box.p[i])));
  return new My3DBox(p);
}

My3DPoint euclidian3DPoint (float[] a) {
  My3DPoint result = new My3DPoint(a[0]/a[3], a[1]/a[3], a[2]/a[3]);
  return result;
}

//=========================================================
//        INTERACTIVITY
//=========================================================

void mouseDragged () {
  if (pmouseY > mouseY)
    scale += 0.05;
  else if (pmouseY < mouseY && scale >= 0.05)
    scale -= 0.05;
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP)
      rotationX += PI/16;
    else if (keyCode == DOWN)
      rotationX -= PI/16;
    else if (keyCode == LEFT)
      rotationY += PI/16;
    else if (keyCode == RIGHT)
      rotationY -= PI/16;
  }   
}