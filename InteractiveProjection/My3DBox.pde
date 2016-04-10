class My3DBox {
  My3DPoint[] p;
  My3DBox(My3DPoint origin, float dimX, float dimY, float dimZ){
    float x = origin.x;
    float y = origin.y;
    float z = origin.z;
    this.p = new My3DPoint[]{/*new My3DPoint(x,y+dimY,z+dimZ),
                             new My3DPoint(x,y,z+dimZ),
                             new My3DPoint(x+dimX,y,z+dimZ),
                             new My3DPoint(x+dimX,y+dimY,z+dimZ),
                             new My3DPoint(x,y+dimY,z),
                             origin,
                             new My3DPoint(x+dimX,y,z),
                             new My3DPoint(x+dimX,y+dimY,z)
                             */
                             new My3DPoint(x-dimX/2,y-dimY/2,z+dimZ/2),
                             new My3DPoint(x-dimX/2,y+dimY/2,z+dimZ/2),
                             new My3DPoint(x+dimX/2,y+dimY/2,z+dimZ/2),
                             new My3DPoint(x+dimX/2,y-dimY/2,z+dimZ/2),
                             new My3DPoint(x-dimX/2,y-dimY/2,z-dimZ/2),
                             new My3DPoint(x-dimX/2,y+dimY/2,z-dimZ/2),
                             new My3DPoint(x+dimX/2,y+dimY/2,z-dimZ/2),
                             new My3DPoint(x+dimX/2,y-dimY/2,z-dimZ/2)
                          };
  }
  My3DBox(My3DPoint[] p) {
    this.p = p; 
  }
}