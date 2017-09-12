//  ******************* Tango dancer 3D 2016 ***********************
//  *******************Author: Congyao Zheng ***********************
//  *********************    11/15/2016   **************************
//  ****************************************************************

// Student's should use this to render their model
Boolean switchArm = false, rotateArm = false, hipChange = false, legLift = false;
pt RightHip = P();
pt LeftHip = P();
float armAngle = PI/6, armRotate = PI/9, HipAngleR = -0.20, HipAngleL = -0.20;
Boolean action = false;
void showDancer(pt LeftFoot, pt RightFoot, vec Forward, vec Side)
  {
  float footRadius=3, kneeRadius = 6,  hipRadius=10, breastRadius =12, shoulderRadius = 7, neckRadius = 7, boobRadius = 10, elbowRadius = 4, wraistRadius = 3, handRadius = 4;  // radius of foot, knee, hip
  float hipSpread = hipRadius; // half-displacement between hips
  float bodyHeight = 100, shoulderHeight = 50, neckLength = 10, boobHeight = 40, armLength = 30, wristLength = 30; // height of body center B
  float legLength = 50;
  
  float ankleBackward=10, ankleInward=4, ankleUp=6, ankleRadius=4; // ankle position with respect to footFront and size
  float pelvisHeight=10, pelvisForward=hipRadius/4, pelvisRadius=hipRadius; // vertical distance form BodyCenter to Pelvis 
  float LeftKneeForward = 20; // arbitrary knee offset for mid (B,H)
  
  pt tempR = RightFoot;
  pt tempL = LeftFoot;
  
  vec Up = U(Side); // up vector
  if(HipAngleR <= -PI/5) {
    RightFoot = tempR;
    LeftFoot = tempL;
    HipAngleR = -0.20;
    HipAngleL = -0.20;
    jump = false;
  }
  if(jump) {
    RightFoot= P(RightFoot.x, RightFoot.y, RightFoot.z + 50);
    LeftFoot= P(LeftFoot.x, LeftFoot.y, LeftFoot.z + 50);
    println("jumping");
    HipAngleR = -PI/5;
    HipAngleL = -PI/5;
  }
  vec Right = N(Up,Forward); // side vector pointing towards the right
  vec Left = N(Forward, Up);
  pt BodyProjection = P();
  //if(legLift){ 
  //  HipAngleR = -PI/4; RightFoot.z += 30;
  //  BodyProjection = P(P(RightFoot.x, RightFoot.y, RightFoot.z-30), 0.33, LeftFoot); 
  //// BODY
  ////}else {
  //HipAngleR = -tan((d(LeftFoot, RightFoot)*(1./3.))/100.);
  //HipAngleL = -tan((d(LeftFoot, RightFoot)*(2./3.))/100.);
  //  if(RightFoot.z > 0 ) RightFoot.z -= 30;
    BodyProjection = P(RightFoot, 0.33, LeftFoot); 
  //}
  pt BodyCenter = P(BodyProjection,bodyHeight,Up);// Body center
  fill(orange); 
  //fill(blue); arrow(BodyCenter,V(100,Forward),5);
  arrow(BodyCenter,V(100,Up),10);
  
  // HIPS
  RightHip =  P(BodyCenter,hipSpread,Right);
  fill(orange);  sphere(RightHip,hipRadius);
  LeftHip =  P(BodyCenter,-hipSpread,Right);
  fill(orange);  sphere(LeftHip,hipRadius);

   
  //KNEE
  vec HipR = V(RightHip,RightFoot);
  pt RightKnee = P(RightHip,50, U(R(HipR, -HipAngleR, Forward, Up)));
  fill(orange); sphere(RightKnee,kneeRadius);
  capletSection(RightHip,hipRadius,RightKnee,kneeRadius);  
  
  vec HipL = V(LeftHip,LeftFoot);
  pt LeftKnee = P(LeftHip, 50, U(R(HipL, -HipAngleL, Forward, Up)));
  fill(orange);  
  sphere(LeftKnee,kneeRadius);
  capletSection(LeftHip,hipRadius,LeftKnee,kneeRadius);  
  //capletSection(LeftKnee,kneeRadius,LeftAnkle,ankleRadius);
  
    // FEET (CENTERS OF THE BALLS OF THE FEET)
  fill(lime);  
  sphere(RightFoot,footRadius);
  pt RightToe =   P(RightFoot,5,Forward);
  capletSection(RightFoot,footRadius,RightToe,1);
  sphere(LeftFoot,footRadius);
  pt LeftToe =   P(LeftFoot,5,Forward);
  capletSection(LeftFoot,footRadius,LeftToe,1);



 // ANKLES
  fill(orange); 
  //pt muscleR = P(RightKnee, 18, U(RightKnee, RightAnkle), -2, Forward);
  //ThreeBallCaplet(RightKnee, kneeRadius, muscleR, kneeRadius+1, RightAnkle, ankleRadius);
  //pt muscleL = P(LeftKnee, 18, U(LeftKnee, LeftAnkle), -2, Forward);
  //ThreeBallCaplet(LeftKnee, kneeRadius, muscleL, kneeRadius+1, LeftAnkle, ankleRadius);
  capletSection(RightFoot,footRadius,RightKnee,kneeRadius);  
  //capletSection(RightKnee,kneeRadius,RightAnkle,ankleRadius);  
  capletSection(LeftFoot,footRadius,LeftKnee,kneeRadius);  
  // capletSection(LeftKnee,kneeRadius,LeftAnkle,ankleRadius);
  //sphere(RightAnkle,ankleRadius);
  //sphere(LeftAnkle,ankleRadius);
 
 //TOE
 pt rightToe = P(RightFoot, 10, Forward);
 fill(pink);
 sphere(rightToe, 4);
 capletSection(RightFoot, footRadius, rightToe, 4);
 pt leftToe = P(LeftFoot, 10, Forward);
  sphere(leftToe, 4);
 capletSection(LeftFoot, footRadius, leftToe, 4);
 fill(orange);
  // PELVIS
  pt Pelvis = P(BodyCenter,pelvisHeight,Up, pelvisForward,Forward); 
  fill(orange); sphere(Pelvis,pelvisRadius);
  capletSection(LeftHip,hipRadius,Pelvis,pelvisRadius);  
  capletSection(RightHip,hipRadius,Pelvis,pelvisRadius);  
  

  pt wrist = P(Pelvis, 10, Up);
  int wristRadius = 7;
  pt breast = P(wrist, 10, Up);
  sphere(wrist, wristRadius); sphere(breast, breastRadius);
  
   //SHOULDER
  pt bigLeft = P(P(BodyCenter, shoulderHeight, Up, -2, Forward), 7, Left);
  pt bigRight = P(P(BodyCenter, shoulderHeight, Up, -2, Forward), 7, Right);
  sphere(bigLeft, breastRadius);sphere(bigRight, breastRadius);
  capletSection(wrist, breastRadius, bigLeft, breastRadius);
  capletSection(wrist, breastRadius, bigRight, breastRadius);
  
  pt LeftShoulder = P(P(BodyCenter, shoulderHeight+2, Up), 15, Left);
  pt RightShoulder = P(P(BodyCenter, shoulderHeight+2, Up), 15, Right);
  sphere(LeftShoulder, shoulderRadius);sphere(RightShoulder, shoulderRadius);
  capletSection(bigLeft, breastRadius, LeftShoulder, shoulderRadius);
  capletSection(bigRight, breastRadius, RightShoulder, shoulderRadius);
  capletSection(LeftShoulder, shoulderRadius, RightShoulder, shoulderRadius);
  
  //NECK
  pt Neck = P(BodyCenter, shoulderHeight + neckLength, Up);
  capletSection(Pelvis, hipRadius, Neck, neckRadius);
  //capletSection(RightShoulder, shoulderRadius, Neck, neckRadius);
  //capletSection(LeftShoulder, shoulderRadius, Neck, neckRadius);
  
  //BBBBB
  pt RightB = P(P(BodyCenter, boobHeight + 5, Up, 6, Forward), 6, Right);
  pt LeftB = P(P(BodyCenter, boobHeight + 5, Up, 6, Forward), 6, Left);
  pt midR = P(RightB, 7, Up, -2, Forward);
  pt midL = P(LeftB, 7, Up, -2, Forward); //<>//
  capletSection(bigRight, breastRadius, RightB, boobRadius);
  capletSection(bigLeft, breastRadius, LeftB, boobRadius);
  
  //ELBOWS
  
  pt RE = P(RightShoulder, armLength, Right);
  pt RightE = R(RE, armAngle, M(Up), Left, RightShoulder);
  pt LE = P(LeftShoulder, armLength, Left);
  pt LeftE = R(LE, armAngle, M(Up), Right, LeftShoulder);
  capletSection(RightE, elbowRadius, RightShoulder, shoulderRadius);
  capletSection(LeftE, elbowRadius, LeftShoulder, shoulderRadius);
  
  //WRAISTS
  pt dummyR = P(RightE, wristLength+4, V(Forward, Right));
  pt dummyL = P(LeftE, wristLength+4, V(Forward,Left));
  pt RightW = P();
  pt LeftW = P();
  //if(!action) {
    RightW = R(dummyR, armRotate, Forward, Up, RightE);
    LeftW = R(dummyL, armRotate,Forward, Up, LeftE);
  //    fill(black);
  //    fanbw(RightW, V(U(RightW, RightE), V(Forward,Right)), 25);
  //    fill(white);
  //    fanwb(RightW, V(U(RightW, RightE), V(Forward,Right)), 10);
  //} else {
  //  RightW = R(dummyR, armRotate, Forward, Left, RightE);
  //  LeftW = R(dummyL, armRotate,Forward, Right, LeftE);
  //    fill(black);
  //    fan(RightW, V(Forward, Right), 25, PI/4);
  //    fill(white);
  //    fan(RightW, V(Forward, Right), 10, PI/4);
  //}

  fill(orange);
  vec RightVec = U(RightE, RightW);
  pt RightHand = P(RightW, -8, RightVec);
  vec leftVec = U(LeftE, LeftW);
  pt LeftHand = P(LeftW, -8, leftVec);
  
  
  //HANDS
  capletSection(RightW, wraistRadius,  RightE, elbowRadius);
  capletSection(LeftW, wraistRadius, LeftE, elbowRadius);
  capletSection(RightHand, handRadius, RightE, elbowRadius);
  capletSection(LeftHand, handRadius, LeftE, elbowRadius);

  
  //DRESS
  //noFill();
  //ThreeBallCapletDress(RightB, boobRadius+2, wrist, breastRadius+2, Pelvis, pelvisRadius+2);
  //noFill();
  //ThreeBallCapletDress(LeftB, boobRadius+2, wrist, breastRadius+2, Pelvis, pelvisRadius+2);
  // float dressTop = hipRadius*2+2, dressBottom = hipRadius*3+2;
  // noFill();
  // ThreeBallCapletDress(wrist, wristRadius+2, BodyCenter, dressTop, P(BodyCenter, -20, Up), dressBottom);
  }
  
void capletSection(pt A, float a, pt B, float b) { // cone section surface that is tangent to Sphere(A,a) and to Sphere(B,b)
    float[] arr = new float[2];
    pt[] v = caplet(A, a, B, b, arr);
    coneSection(v[0], v[1], arr[1], arr[0]);
  }
  
pt[] caplet(pt A, float a, pt B, float b, float[] f) {
    sphere(A, a); sphere(B, b);
    float h = sqrt(d(A, B)*d(A, B) - (b - a)*(b - a));
    float x = ((b*h))/(d(A, B));
    float y = x*(a/b);
    pt[] pts = new pt[2];
    pt V = P(B, V((x/h*(b-a)), U(B, A)));
    pt U = P(A, V((y/h*(b-a)), U(B, A)));
    pts[0] = U; pts[1] = V;
    f[0] = x; f[1] = y;
    return pts;
    
}
  
void ThreeBallCaplet(pt A, float a, pt B, float b, pt C, float c) {
  float[] arr1 = new float[2];
  float[] arr2 = new float[2];
  pt[] v1 = caplet(A, a, B, b, arr1);
  pt[] v2 = caplet(B, b, C, c, arr2);
  pt U = v1[0], V = v1[1], W = v2[0], X = v2[1];
  
  pt[] top = new pt[37], middle1 = new pt[37], middle2 = new pt[37], bottom = new pt[37];
  conePts(U, V, arr1[1], arr1[0], top, middle1); conePts(W, X, arr2[1],arr2[0], middle2, bottom);
  for(int i = 0; i < 37; i++) {
    pt first = top[i], second = middle1[i], thrd = middle2[i], fourth = bottom[i];
    pt aim = P(second, thrd);
    pt third = P(B, b+0.5, U(B, aim));
    pt sec = middle1[(i+1)%36], thd = middle2[(i+1)%36];
    pt thir = P(B, b+0.5, U(B, P(sec, thd)));
      beginShape(QUAD_STRIP);
      for(float s = 0; s<1; s += 0.1) {
        pt one = N(0.0, first, 0.5,third, 1, fourth, s); 
        pt two = N(0.0, first, 0.5,third, 1, fourth, s + 0.1);
        pt three = N(0.0, top[(i+1)%36], 0.5, thir, 1, bottom[(i+1)%36], s);
        pt four = N(0.0, top[(i+1)%36], 0.5, middle2[(i+1)%36], 1, bottom[(i+1)%36], s+0.1);
          v(one);
          //v(two);
          //v(four);
          v(three);
      }
    endShape();
  }
}
  void ThreeBallCapletDress(pt A, float a, pt B, float b, pt C, float c) {
  float[] arr1 = new float[2];
  float[] arr2 = new float[2];
  pt[] v1 = caplet(A, a, B, b, arr1);
  pt[] v2 = caplet(B, b, C, c, arr2);
  pt U = v1[0], V = v1[1], W = v2[0], X = v2[1];
  
  pt[] top = new pt[37], middle1 = new pt[37], middle2 = new pt[37], bottom = new pt[37];
  conePts(U, V, arr1[1], arr1[0], top, middle1); conePts(W, X, arr2[1],arr2[0], middle2, bottom);
  for(int i = 0; i < 37; i++) {
    pt first = top[i], second = middle1[i], thrd = middle2[i], fourth = bottom[i];
    pt aim = P(second, thrd);
    pt third = P(B, b+0.5, U(B, aim));
      beginShape(QUAD_STRIP);
      for(float s = 0; s<1; s += 0.1) {
        fill(black);
        pt one = N(0.0, first, 0.5,third, 1, fourth, s); 
        pt two = N(0.0, first, 0.5,third, 1, fourth, s + 0.1);
        pt three = N(0.0, top[(i+1)%36], 0.5, middle2[(i+1)%36], 1, bottom[(i+1)%36], s);
        pt four = N(0.0, top[(i+1)%36], 0.5, middle2[(i+1)%36], 1, bottom[(i+1)%36], s+0.1);
          v(one);
          v(three);
          v(two);
          v(four); 
      }
    endShape();
  }

}