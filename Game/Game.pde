
float rotationX = 0.0;
float rotationZ = 0.0;

float plateWidth = 250;
float plateLength = 250;
float plateHeight = 10;
float speed = 0.025;

float ballRadius = 10;
Mover ball = new Mover();

Cylinder cylinder;
ArrayList<PVector> cylinders = new ArrayList<PVector>();

final float FRAMERATE = 30;
enum Mode{
 PLAY, 
 EDIT
};
Mode mode = Mode.PLAY;

void settings() {
   size(500, 500, P3D);
}

void setup() {
   camera(width/2, 0, (height/2.0) / tan(PI * 45.0 / 180.0), 
      width/2, height/2, 0, 
      0, 1, 0);
   frameRate(FRAMERATE);
   noStroke();
   cylinder = new Cylinder();
}

void draw() {
  background(200);
  lights();
  directionalLight(100, 100, 100, -1, 1, 0);
  pushMatrix();
  translate(width/2, height/2, 0);
  fill(100, 255, 100);
  
  switch(mode)
  {
    case PLAY:
      rotateX(rotationX);
      rotateZ(rotationZ);
      ball.update();
      break;
    case EDIT:
      rotateX((PI * 45.0 / 180.0) -PI/2);
      break;
    default:
      break;
  }
  
  box(plateWidth, plateHeight, plateLength);
      
  translate(0,-5 -ballRadius, 0); // on met la boule à hauteur du plateau
  pushMatrix();
  translate(ball.location.x, ball.location.y, ball.location.z);  // on place la boule au bon endroit
  fill(100, 100, 100);
  sphere(ballRadius);
  popMatrix();
      
  translate(0, ballRadius, 0);  // On revient à hauteur du plateau EXACT
      
  for(int i = 0 ; i < cylinders.size() ; ++i)
  {
    pushMatrix();
    translate(cylinders.get(i).x, 0, cylinders.get(i).z);
    shape(cylinder.getCylinder());
    popMatrix();
  }
  popMatrix();
  
  afficherStats();
}

void afficherStats()
{
  textSize(32);
  switch(mode)
  {
    case EDIT:
      pushMatrix();
      rotateX(PI * 45.0 / 180.0);
      fill(0);
      text("Clic gauche : placer un obstacle", -100, -150, -500);
      text("Clic droit : enlever l'obstacle", -100, -100, -500);
      popMatrix();
      break;
    case PLAY:
      pushMatrix();
      rotateX(PI * 45.0 / 180.0);
      fill(0);
      text("Vitesse de rotation du plateau : " + int(speed*1000), -100, -150, -500);
      popMatrix();
      break;
    default:
      break;
  }
}

void keyPressed()
{
  if (key == CODED)
    if (keyCode == SHIFT)
      mode = Mode.EDIT;
}

void keyReleased()
{
  if (key == CODED)
    if (keyCode == SHIFT)
      mode = Mode.PLAY;
}

void mouseDragged()
{
  switch(mode)
  {
    case PLAY:
      if (pmouseY < mouseY)
        rotationX -= speed;
      else if (pmouseY > mouseY)
        rotationX += speed;
      if (pmouseX < mouseX)
        rotationZ += speed;
      else if (pmouseX > mouseX)
        rotationZ -= speed;
        
      if (rotationX >= PI/3)
        rotationX = PI/3;
      if (rotationX <= -PI/3)
        rotationX = -PI/3;
      if (rotationZ >= PI/3)
        rotationZ = PI/3;
      if (rotationZ <= -PI/3)
        rotationZ = -PI/3;
      break;
    default:
      break;
  }
}

void mouseWheel(MouseEvent event){
  switch(mode)
  {
    case PLAY:
      if (event.getCount() > 0)
        speed = speed * 0.9;
      else if (event.getCount() < 0)
        speed = speed * 1.1;
      if (speed < 0.001)
        speed = 0.001;
      if (speed > 0.1)
        speed = 0.1;
      break;
    default:
      break;
  }
}

void mousePressed()
{
  switch(mode)
  {
    case EDIT:
      float x =map(mouseX-width/2, -155, 155, -plateWidth/2, plateWidth/2);
      float z =map(mouseY-height/2, -155, 155, -plateLength/2, plateLength/2);
      
      //PVector mapped = mapMouse(mouseX-width/2, mouseY-height/2);
      PVector d = new PVector(x - ball.location.x, 
                              0, 
                              z - ball.location.z);
      float d_size = sqrt(d.x*d.x + d.z*d.z);
                              
      if (mouseButton == LEFT && d_size > ballRadius + cylinder.getBaseSize() &&
          x >= -plateWidth/2 && x <= plateWidth/2 &&
          z >= -plateLength/2 && z <= plateLength/2)
      {
        cylinders.add(new PVector(x, 0, z));
      }
      else if (mouseButton == RIGHT)
      {
        for (int i = 0 ; i < cylinders.size() ; ++i)
        {
          PVector n = new PVector(cylinders.get(i).x - x, 
                                  0,
                                  cylinders.get(i).z - z);
          float n_size = sqrt(n.x*n.x + n.z*n.z);
          if (n_size < cylinder.getBaseSize())
          {
            cylinders.remove(i);
          }
        }
      }
      break;
    default:
      break;
  }
}