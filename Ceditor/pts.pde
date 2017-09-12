boolean switchedLegTTUpdate = false;

class pts // class for manipulaitng and displaying pointclouds or polyloops in 3D 
  { 
    int maxnv = 16000;                 //  max number of vertices
    pt[] G = new pt [maxnv];           // geometry table (vertices)
    char[] L = new char [maxnv];             // labels of points
    vec [] LL = new vec[ maxnv];  // displacement vectors
    Boolean loop=true;          // used to indicate closed loop 3D control polygons
    int pv =0,     // picked vertex index,
        iv=0,      //  insertion vertex index
        dv = 0,   // dancer support foot index
        nv = 0,    // number of vertices currently used in P
        pp=1; // index of picked vertex

  pts() {}
  pts declare() 
    {
    for (int i=0; i<maxnv; i++) G[i]=P(); 
    for (int i=0; i<maxnv; i++) LL[i]=V(); 
    return this;
    }     // init all point objects
  pts empty() {nv=0; pv=0; return this;}                                 // resets P so that we can start adding points
  pts addPt(pt P, char c) { G[nv].setTo(P); pv=nv; L[nv]=c; nv++;  return this;}          // appends a new point at the end
  pts addPt(pt P) { G[nv].setTo(P); pv=nv; L[nv]='f'; nv++;  return this;}          // appends a new point at the end
  pts addPt(float x,float y) { G[nv].x=x; G[nv].y=y; pv=nv; nv++; return this;} // same byt from coordinates
  pts copyFrom(pts Q) {empty(); nv=Q.nv; for (int v=0; v<nv; v++) G[v]=P(Q.G[v]); return this;} // set THIS as a clone of Q

  pts resetOnCircle(int k, float r)  // sets THIS to a polyloop with k points on a circle of radius r around origin
    {
    empty(); // resert P
    pt C = P(); // center of circle
    for (int i=0; i<k; i++) addPt(R(P(C,V(0,-r,0)),2.*PI*i/k,C)); // points on z=0 plane
    pv=0; // picked vertex ID is set to 0
    return this;
    } 
  // ********* PICK AND PROJECTIONS *******  
  int SETppToIDofVertexWithClosestScreenProjectionTo(pt M)  // sets pp to the index of the vertex that projects closest to the mouse 
    {
    pp=0; 
    for (int i=1; i<nv; i++) if (d(M,ToScreen(G[i]))<=d(M,ToScreen(G[pp]))) pp=i; 
    return pp;
    }
  pts showPicked() {show(G[pv],23); return this;}
  pt closestProjectionOf(pt M)    // Returns 3D point that is the closest to the projection but also CHANGES iv !!!!
    {
    pt C = P(G[0]); float d=d(M,C);       
    for (int i=1; i<nv; i++) if (d(M,G[i])<=d) {iv=i; C=P(G[i]); d=d(M,C); }  
    for (int i=nv-1, j=0; j<nv; i=j++) { 
       pt A = G[i], B = G[j];
       if(projectsBetween(M,A,B) && disToLine(M,A,B)<d) {d=disToLine(M,A,B); iv=i; C=projectionOnLine(M,A,B);}
       } 
    return C;    
    }

  // ********* MOVE, INSERT, DELETE *******  
  pts insertPt(pt P) { // inserts new vertex after vertex with ID iv
    for(int v=nv-1; v>iv; v--) {G[v+1].setTo(G[v]);  L[v+1]=L[v];}
     iv++; 
     G[iv].setTo(P);
     L[iv]='f';
     nv++; // increments vertex count
     return this;
     }
  pts insertClosestProjection(pt M) {  
    pt P = closestProjectionOf(M); // also sets iv
    insertPt(P);
    return this;
    }
  pts deletePicked() 
    {
    for(int i=pv; i<nv; i++) 
      {
      G[i].setTo(G[i+1]); 
      L[i]=L[i+1]; 
      }
    pv=max(0,pv-1); 
    nv--;  
    return this;
    }
  pts setPt(pt P, int i) { G[i].setTo(P); return this;}
  
  pts drawBalls(float r) {for (int v=0; v<nv; v++) show(G[v],r); return this;}
  pts showPicked(float r) {show(G[pv],r); return this;}
  pts drawClosedCurve(float r) 
    {
    fill(dgreen);
    for (int v=0; v<nv; v++) show(G[v],r*3); 
    fill(magenta);
    for (int v=0; v<nv-1; v++) stub(G[v],V(G[v],G[v+1]),r,r);  
    stub(G[nv-1],V(G[nv-1],G[0]),r,r);
    pushMatrix(); //translate(0,0,1); 
    scale(1,1,0.03);  
    fill(grey);
    for (int v=0; v<nv; v++) show(G[v],r*3);    
    for (int v=0; v<nv-1; v++) stub(G[v],V(G[v],G[v+1]),r,r);  
    stub(G[nv-1],V(G[nv-1],G[0]),r,r);
    popMatrix();
    return this;
    }
  pts set_pv_to_pp() {pv=pp; return this;}
  pts movePicked(vec V) { G[pv].add(V); return this;}      // moves selected point (index p) by amount mouse moved recently
  pts setPickedTo(pt Q) { G[pv].setTo(Q); return this;}      // moves selected point (index p) by amount mouse moved recently
  pts moveAll(vec V) {for (int i=0; i<nv; i++) G[i].add(V); return this;};   
  pt Picked() {return G[pv];} 
  pt Pt(int i) {if(0<=i && i<nv) return G[i]; else return G[0];} 

  // ********* I/O FILE *******  
 void savePts(String fn) 
    {
    String [] inppts = new String [nv+1];
    int s=0;
    inppts[s++]=str(nv);
    for (int i=0; i<nv; i++) {inppts[s++]=str(G[i].x)+","+str(G[i].y)+","+str(G[i].z)+","+L[i];}
    saveStrings(fn,inppts);
    };
  
  void loadPts(String fn) 
    {
    println("loading: "+fn); 
    String [] ss = loadStrings(fn);
    String subpts;
    int s=0;   int comma, comma1, comma2;   float x, y;   int a, b, c;
    nv = int(ss[s++]); print("nv="+nv);
    for(int k=0; k<nv; k++) 
      {
      int i=k+s; 
      //float [] xy = float(split(ss[i],",")); 
      String [] SS = split(ss[i],","); 
      G[k].setTo(float(SS[0]),float(SS[1]),float(SS[2]));
      L[k]=SS[3].charAt(0);
      }
    pv=0;
    };
 
  // Dancer
  void setPicekdLabel(char c) {L[pp]=c;}
  


  void setFifo() 
    {
    _LookAtPt.reset(G[dv],60);
    }              


  void next() {dv=n(dv);}
  int n(int v) {return (v+1)%nv;}
  int p(int v) {if(v==0) return nv-1; else return v-1;}
  
  pt NUBS(float a, pt A, float b, pt B, float c, pt C, float d, pt D, float e, pt Z, float t) {
      pt E = L(A,(a+b+t*c)/(a+b+c),B), F = L(B,(b+t*c)/(b+c+d),C), G = L(C,(t*c)/(c+d+e),D), H = L(E,(b+t*c)/(b+c),F), I = L(F,(t*c)/(c+d),G),
      J = L(H,t,I);
      return J; }
  
  void controlNUBS(pts L) {
    L.nv = 0;
    for (int j = 0; j < nv; j++) {
      int i = p(p(j));
      L.G[L.nv++] = NUBS(d(G[i], G[n(i)]), G[n(i)], d(G[n(i)], G[n(n(i))]), G[n(n(i))], 
                          d(G[n(n(i))], G[n(n(n(i)))]), G[n(n(n(i)))],  d(G[n(n(n(i)))], G[n(n(n(n(i))))]), G[n(n(n(n(i))))], 
                          d(G[n(n(n(n(i))))], G[n(n(n(n(n(i)))))]), G[n(n(n(n(n(i)))))], 0);
    }
  }
  
  pts subdivideDemoInto(pts Q) 
    {
     
    Q.empty();
    for(int i=0; i<nv; i++)
      {
      Q.addPt(P(G[i])); 
      Q.addPt(P(G[i],G[n(i)])); 
      //...
      }
    return this;
    }  
   
   pts subdivideFourPoint(pts Q) 
    {
    Q.empty();
    int k = 0;
    //while(k <=3) {
    for(int i=0; i<nv*2; i++)
      {
      //fill(pink);
      //show(P(G[i/2]), 9);
      Q.addPt(P(G[i/2])); 
      i++;
      //show((P(G[p((i-1)/2)]).mul(-1).add( P(G[(i-1)/2]).mul(9)).add( P(G[n((i-1)/2)]).mul(9)).add(P(G[n(n((i-1)/2))]).mul(-1))).div(16), 9);
      Q.addPt((P(G[p((i-1)/2)]).mul(-1).add( P(G[(i-1)/2]).mul(9)).add( P(G[n((i-1)/2)]).mul(9)).add(P(G[n(n((i-1)/2))]).mul(-1))).div(16));
      
      }

    return this;
    }  

    pts subdivideCubicSpline(pts Q) 
    {
    Q.empty();
    int k = 0;
    //while(k <=3) {
    for(int i=0; i<nv*2; i++)
      {
      //fill(pink);
        
        if (i%2==0) {Q.addPt((P(G[p(i/2)]).add(P(G[i/2]).mul(6)).add(P(G[n(i/2)]))).div(8)); 

        }
        else {Q.addPt((P(G[(i-1)/2]).mul(8).add(P(G[n((i-1)/2)]).mul(8))).div(16));
            
        }
      }
    return this;
    } 
   
  pts subdivideQuadraticSpline(pts Q) 
    {
    Q.empty();
    int k = 0;
    //while(k <=3) {
    for(int i=0; i<nv*2; i++)
      {
      //fill(pink);
        
        if (i%2==0) {Q.addPt(((P(G[p(i/2)]).mul(0.689)).add(P(G[i/2]).mul(8.-2.*0.689)).add(P(G[n(i/2)]).mul(0.689))).div(8.)); }
        else {Q.addPt((P(G[p((i-1)/2)]).mul(0.689-1.).add( P(G[(i-1)/2]).mul(9.-0.689)).add( P(G[n((i-1)/2)]).mul(9.-0.689)).add(P(G[n(n((i-1)/2))]).mul(0.689-1.))).div(16.));
        }
      }
    return this;
    } 
      pts subdivideQuintic(pts Q) 
    {
    Q.empty();
    int k = 0;
    //while(k <=3) {
    for(int i=0; i<nv*2; i++)
      {
      //fill(pink);
        
        if (i%2==0) {Q.addPt(((P(G[p(i/2)]).mul(1.5)).add(P(G[i/2]).mul(8.-2.*1.5)).add(P(G[n(i/2)]).mul(1.5))).div(8.)); }
        else {Q.addPt((P(G[p((i-1)/2)]).mul(1.5-1.).add( P(G[(i-1)/2]).mul(9.-1.5)).add( P(G[n((i-1)/2)]).mul(9.-1.5)).add(P(G[n(n((i-1)/2))]).mul(1.5-1.))).div(16.));
        }
      }
    return this;
    } 
    

  
  pt[] offset(pt[] B, vec F) {
    pt[] ret = new pt[nv];
         for (int j=0; j<nv; j++){
           vec g = M(V(9.8, U(B[j], G[j])));
           vec a = M(V(B[n(j)], B[j]), V(B[j], B[p(j)]));
           //vec V = M(g, a);
           F = M(V(15, g), V(5*level, a));
           if(showOffset){
           fill(pink);
           arrow(B[j],F, 3);
           }
           //vec Up = V(0,0,1);
           //arrow(B[j], a, 3);
           ret[j] = P(B[j], F);
         }
    return ret;
  }
 
  vec forwardOnB(pt[] B, int j) {
    vec g = M(V(9.8, U(B[j], G[j])));
    vec a = M(V(B[n(j)], B[j]), V(B[j], B[p(j)]));
    vec f = M(V(15, g), V(5*level, a));
    //vec v = V(V(B[j], B[p(j)]), V(B[n(j)], B[j]));
    //vec forward = U(v);
    return f;
  }
    
  void displaySkater() 
      {
      if(showCurve) {fill(yellow); for (int j=0; j<nv; j++) caplet(G[j],6,G[n(j)],6); }
      pt[] B = new pt [nv];           // geometry table (vertices)
      for (int j=0; j<nv; j++) B[j]=P(G[j],V(0,0,100));
      vec F = V(0,0,0);
      pt[] O = offset(B, F);

      if(showPath) {

         fill(white);
         for (int j = 0; j < nv; j++) { 
         vec v = V(V(B[j], B[p(j)]), V(B[n(j)], B[j]));
           beginShape();
             v(P(B[j], 30, R(U(v))));
             v(P(B[j], 30,R(M(U(v)))));
             v(P(B[n(j)], 30, R(M(U(v)))));
             v(P(B[n(j)], 30, R(U(v))));
             println("ehy");
           endShape(CLOSE);
           beginShape();
             v(P(P(B[p(j)],B[j]), 30, R(U(v))));
             v(P(P(B[p(j)],B[j]), 30,R(M(U(v)))));
             v(P(P(B[j],B[n(j)]), 30, R(M(U(v)))));
             v(P(P(B[j],B[n(j)]), 30, R(U(v))));
             println("ehy");
           endShape(CLOSE);
         }
         fill(pink);
         if(showCurve) {
          fill(lime); 
          for (int j=0; j<nv; j++) {show(B[j], 6); caplet(B[j],6,B[n(j)],6);}
         
         }
         if(showOffset) {
           fill(orange);
         for (int j=0; j<nv; j++) {show(O[j], 6); caplet(O[j],6,O[n(j)],6);}
         }
      } 
      if(showKeys) {fill(green); for (int j=0; j<nv; j+=4) arrow(B[j],G[j],3);}
      
      if(animating) f=n(f);
      if(showSkater) 
        {
          fill(red);
          //arrow(B[f], forwardOnB(B, f), 20);
          
          //float d = d(B[p(f)], B[n(f)]);
          //pt left = B[n(f)];
          //if(d > 32) {
          //  //d = d - 70.19;
          //  left = P(B[p(f)], 31, M(U(v)));
          //}
          
          
          if(!showRunner) {
            vec v = V(V(B[f], B[p(f)]), V(B[n(f)], B[f]));
            vec Up = forwardOnB(B, f);
            
            pt left = P(B[f], 10, R(U(v)));
            pt right = P(B[f], 10, R(M(U(v))));
            fill(red);
            beginShape();
            v(P(P(left, 50, U(v)), 5, R(U(v))));
            v(P(P(left, 50, U(v)), 5, R(M(U(v)))));
            v(P(P(left, 50, M(U(v))), 5, R(M(U(v)))));
            v(P(P(left, 50, M(U(v))), 5, R(U(v))));
            endShape(CLOSE);
            beginShape();
            v(P(P(right, 50, U(v)), 5, R(U(v))));
            v(P(P(right, 50, U(v)), 5, R(M(U(v)))));
            v(P(P(right, 50, M(U(v))), 5, R(M(U(v)))));
            v(P(P(right, 50, M(U(v))), 5, R(U(v))));
            endShape(CLOSE);
          showDancer(left, right,M(U(v)), forwardOnB(B, f));
          //showDancer(B[p(p(f))], B[n(f)],M(U(v)), forwardOnB(B, f));
          //showDancer(tt, B, forwardOnB(B, f));
          }
          
          if(showRunner) {
             if(animating)  
            {
            f++; // advance frame counter
            if (f>(maxf)) // if end of step
              {
             switchedLegTTUpdate = false;
             next();     // advance dv in P to next vertex
             //next();
         //     animating=true;  
              f=0;
              }
            }  
            vec v = V(V(B[dv], B[p(dv)]), V(B[n(dv)], B[dv]));
             //vec v = V(V(B[p(dv)], B[p(p(dv))]), V(B[dv], B[p(dv)]));
            //vec v2 = V(V(B[n(dv)], B[dv]), V(B[n(n(dv))], B[n(dv)]));
            vec Up = forwardOnB(B, dv);
            
            pt C = P(B[dv], d(B[dv], B[n(dv)]), M(U(v)));
            pt A = P(B[dv], d(B[dv], B[n(dv)]), U(v));
            pt BB = P();
            println(jump);

  
            if(dv%2 == 0) {
                //showDancerOnRight(B[p(p(p(dv)))], B[p(dv)], B[n(dv)], tt, M(U(v)), Up);
                if (!switchedLegTTUpdate) {tt=0;switchedLegTTUpdate=true;}
                showDancerOnRight(A, B[dv], C, tt, M(U(v)), Up);
                
                 //if(!hipChange && !legLift){HipAngleR -= 0.003; HipAngleL += 0.003;if(HipAngleR < PI/18) hipChange = true;}
              } else {
                  //showDancerOnLeft(B[p(p(p(dv)))],B[p(dv)], B[n(dv)], tt, M(U(v)), Up);
                  if (!switchedLegTTUpdate) {tt=0;switchedLegTTUpdate=true;}
                  showDancerOnLeft(A, B[dv], C, tt, M(U(v)), Up);
                //if(hipChange && !legLift) {HipAngleR += 0.003; HipAngleL -= 0.003;if(HipAngleR < PI/4) hipChange = false;}
              }
        }
        }
      else {fill(red); arrow(B[f],O[f],20);} //
      }

   void setTo(pts P, pts Q) {
     P.empty();
     for(int i = 0; i < Q.nv; i++) {
       P.addPt(Q.G[i]);
     }
   }
   
  //void showDancer(float s, pts B) {
  //  pt[] X = new pt[B.nv];
  //  for(int i = 0; i < B.nv; i++) {
  //    X[i] = B.G[i];
  //  }
  //  vec Up = forwardOnB(X, p(dv));
  //  vec v = V(V(X[p(dv)], X[p(p(dv))]), V(X[dv], X[p(dv)]));
  //if(pv%2 == 0) {
  //    showDancerOnRight(B.G[p(p(dv))], B.G[p(dv)], B.G[dv], s, M(U(v)),Up);
  //     if(!hipChange && !legLift){HipAngleR -= 0.003; HipAngleL += 0.003;if(HipAngleR < PI/18) hipChange = true;}
  //  } else {
  //      showDancerOnLeft(B.G[p(p(dv))],B.G[p(dv)], B.G[dv], s, M(U(v)), Up);
  //    if(hipChange && !legLift) {HipAngleR += 0.003; HipAngleL -= 0.003;if(HipAngleR < PI/4) hipChange = false;}
  //  }
  //}
} // end of pts class