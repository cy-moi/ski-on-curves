//  ******************* Tango dancer 3D 2016 ***********************
//  *******************Author: Congyao Zheng ***********************
//  *********************    11/15/2016   **************************
//  ****************************************************************
int support=0; // ID of vertex where support foot is located
boolean WeightOnRight = true;
float time = 0;
float r=100;
vec ForwardDirection = V(1,0,0);
pt[] ret = new pt[10];
String footMessage = "";
void showDancerOnRight(pt A, pt B, pt C, float t, vec ForwardDirection, vec Up)  // R=B L moves from A to C
  {
   A = P(A.x, A.y, A.z + 6);
   B = P(B.x, B.y, B.z + 6);
   C = P(C.x, C.y, C.z + 6);
   footMessage = "Right";
   pt Right = B;
   pt Left = A;
   //if (t>0.95) {
   //  println(A.x);
   //  println(B.x);
   //  println(C.x);
   //  println(t);
   //}
   if(t>1./2) {
   
    //pt newP = P(B, C);
    vec f = R(R(R(ForwardDirection)));
    pt mid = P(B, 10, f);
    //pt old = P(B, 5, f);
    //pt m = P(B, 5, R(U(C, B)));
    //pt forward = N2(0.0, old, 0.5, m, 1.0, newP, t);
   Left = N2(0.5,A,.75,mid,1.,C,t); 
   Right = B;
  // ForwardDirection = U(B, forward);
   }if(t > 0 && t <= 1./2) {
    Left = A;
    Right  = B;
   }
   showDancer(Left, Right, ForwardDirection, Up); 
   //println(Left.x);
   //println(t);
  //showDancer(R, s, L, ForwardDirection);
  }
void showDancerOnLeft(pt A, pt B, pt C, float t, vec ForwardDirection, vec Up)  // R=B L moves from A to C
  {
       A = P(A.x, A.y, A.z + 6);
   B = P(B.x, B.y, B.z + 6);
   C = P(C.x, C.y, C.z + 6);
    footMessage = "Left";
       pt Right = A;
   pt Left = B;
    if(t > 1./2) {
      pt newP = P(B, C);
      //pt m = P(B, newP);
       pt mid = P(B, 10, R(ForwardDirection));
      //pt old = P(B, 5, R(ForwardDirection));
      //pt m = P(B, 5, R(U(B, C)));
     // pt forward = N2(0.0, old, 0.5, m, 1.0, newP, t);
      Right = N2(0.5,A,.75,mid,1.,C,t); 
      Left = B;
      //ForwardDirection = U(B, forward);
    } if(t <= 1./2) {
       Right = A;
       Left  = B;
    }
  //println(ForwardDirection.x);
  if (Float.isNaN(ForwardDirection.x)) {ForwardDirection = V(1,0,0);}
  //ForwardDirection = V(W.x, W.y, 0);
  showDancer(Left, Right, ForwardDirection, Up); 
  }
  
 vec Rx(vec V, float a) { return W(cos(a),V,sin(a),R(V)); }                                           // V rotated by angle a in radians
vec W(float u, vec U, float v, vec V) {return W(S(u,U),S(v,V));}                                   // uU+vV ( Linear combination)
vec S(float s,vec V) {return new vec(s*V.x,s*V.y, s*V.z);};                                                  // sV
vec W(vec U, vec V) {return V(U.x+V.x,U.y+V.y, U.z + V.z);}                                                   // U+V 
vec V(float x, float y) {return new vec(x,y); };                                                      // make vector (x,y)
pt N1(float a, pt A, float b, pt B, float t) {return P((b-t)/(b-a)*A.x+(t-a)/(b-a)*B.x,(b-t)/(b-a)*A.y+(t-a)/(b-a)*B.y, (b-t)/(b-a)*A.z+(t-a)/(b-a)*B.z);  } 
pt N2(float a, pt A, float b, pt B, float c, pt C, float t) {pt P = N1(a,A,b,B,t), Q = N1(b,B,c,C,t); return N1(a,P,c,Q,t);}
pt N3(float a, pt A, float b, pt B, float c, pt C, float d, pt D, float t) {pt P = N2(a,A,b,B,c,C,t), Q = N2(b,B,c,C,d,D,t); return N1(a,P,d,Q,t);}