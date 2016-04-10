class Mover {
      PVector location;
      PVector velocity;
      float gravityConstant;
      float elasticiteBord;
      float elasticiteObstacle;
      PVector gravity;
      
      
      Mover() {
        location = new PVector(0, 0, 0);
        velocity = new PVector(0, 0, 0);
        gravity = new PVector(0, 0, 0);
        gravityConstant = 9.81;
        elasticiteBord = 0.5;
        elasticiteObstacle = 0.9;
      }
      
      void update() {
        gravity.x = sin(rotationZ) * gravityConstant / FRAMERATE;
        gravity.z = -sin(rotationX) * gravityConstant / FRAMERATE;
        velocity.add(gravity);
        float normalForce = 1;
        float mu = 0.05; // par défaut 0.01
        float frictionMagnitude = normalForce * mu;
        PVector friction = velocity.copy();
        friction.mult(-1);
        friction.normalize();
        friction.mult(frictionMagnitude);
        
        velocity.add(friction);
        location.add(velocity);
        checkEdges();
        checkCylinderCollision();
      }
      
      void checkEdges() {
        if (location.x > plateWidth/2) {
          location.x = plateWidth/2;
          velocity.x = velocity.x*-1*elasticiteBord;
        }
        else if (location.x < -plateWidth/2) {
          location.x = -plateWidth/2;
          velocity.x = velocity.x*-1*elasticiteBord;
        }
        if (location.z > plateLength/2) {
          location.z = plateLength/2;
          velocity.z = velocity.z*-1*elasticiteBord;
        }
        else if (location.z < -plateLength/2) {
          location.z = -plateLength/2;
          velocity.z = velocity.z*-1*elasticiteBord;
        }
      } 
      
      void checkCylinderCollision() {
        for (int i = 0 ; i < cylinders.size() ; ++i)
        {
          PVector n = new PVector(cylinders.get(i).x - location.x, 
                                  0,
                                  cylinders.get(i).z - location.z);
          float n_size = sqrt(n.x*n.x + n.z*n.z);
          float limite = cylinder.getBaseSize() + ballRadius;
          if (n_size < limite)
          {
            PVector ntmp = n.copy();
            PVector n_norm = ntmp.normalize();
            PVector v1 = velocity.copy();
            velocity.sub(n_norm.mult(2*(v1.dot(n_norm)))).mult(elasticiteObstacle);
            
            n.mult(-1);
            location.add(new PVector(n.x * (limite-n_size) / n_size, 
                                   0, 
                                   n.z * (limite-n_size) / n_size));
          }
        }
      }

}