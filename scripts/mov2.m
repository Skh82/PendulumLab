function dX=mov2(~,X,M, m, g, m1, m2, L1, L2, mp1, lp1, mp2, lp2)

x_dot=X(2,1);
theta1=X(3,1);
theta1_dot=X(4,1);
theta2=X(5,1);
theta2_dot=X(6,1);

dX(1,1)=x_dot;
dX(3,1)=theta1_dot;
dX(5,1)=theta2_dot;

IB = m2*L2^2/12+m2*(L2/2)^2 +2*m*0.05^2/5+m*(L2)^2 + 1+mp2*lp2^2;
IA = m1*L1^2/12+m1*(L1/2)^2 + 1+mp1*lp1^2;
Rx1 = cos(theta1)*(m1*L1/2+mp1*lp1)/(m1+mp1);
Ry1 = sin(theta1)*(m1*L1/2+mp1*lp1)/(m1+mp1);
Rx2 = cos(theta2)*(m2*L2/2+mp2*lp2+m*L2)/(m2+m+mp2);
Ry2 = sin(theta2)*(m2*L2/2+mp2*lp2+m*L2)/(m2+m+mp2);
mT1 = m1+mp1;   mT2 = m2+mp2+m;

B=[-Ry2*mT2,  Rx2*mT2*L1*cos(theta1)+Ry2*mT2*L1*sin(theta1)  ,   IB;
   M+mT1+mT2,  -mT1*Ry1-mT2*L1*sin(theta1)  ,  -mT2*Ry2;
   -M*L1*sin(theta1)-mT1*L1*sin(theta1)+mT1*Ry1  ,  mT1*L1*sin(theta1)*Ry1-mT2*L1^2*(cos(theta1))^2-IA  ,  -mT2*L1*cos(theta1)*Rx2];
C=[-mT2*g*Rx2+Rx2*theta1_dot^2*L1*sin(theta1)*mT2-Ry2*mT2*theta1_dot^2*L1*cos(theta1); 
   mT1*theta1_dot^2*Rx1+mT2*theta1_dot^2*L1*cos(theta1)+mT2*theta2_dot^2*Rx2;
   -mT1*L1*sin(theta1)*theta1_dot^2*Rx1+mT1*Rx1*g+mT2*g*L1*cos(theta1)-L1^2*cos(theta1)*mT2*theta1_dot^2*sin(theta1)-mT2*L1*cos(theta1)*theta2_dot^2*Ry2;
   ];

A=B\C;
dX(2,1)=A(1);
dX(4,1)=A(2);
dX(6,1)=A(3);