clear all; echo off;

D0=1000; %dalnost 
B=0.2; %razmer bazi interferometra 
lambda=0.008; %dlina volni 
ug2=1.5708; %ogol nablyudeniya
v=55.5; %skorost LA 
H0=30; %visota LA

deltaR=20; %%razreshaushaya sposobnost po dalnosti
deltaLaz=20; %razreshaushaya sposobnost po azimutu

fi=unifrnd(-0,0,500,500); %ravnomernoe raspredelenie fazi
M=500; N=500; 
Ai=6; Aw=1;
Hi=2; Hw=0;	

Ltest1=imread('iceberg.jpg'); %schitivaem izobrajenie iz faila
Ltest2=double(Ltest1)./255; %poluchaem trehmerniy massiv
Ltest3=rgb2gray(Ltest2); %preobrazovanie iz cvetnogo izobrajenia v chb
imwrite(Ltest3,'ice_water_1.jpg'); %sohranenie kartinki v fail
dlmwrite('ice_water_massiv.txt',Ltest3); %sohranenie massiva v textoviy fail
mAmp=dlmread('ice_water_massiv.txt'); %massiv s dannimi o poverhnosti iz textovogo faila


dAw=0.05; dAi=1;	
A=zeros(M,N);
 
 for m=1:M		
     for n=1:N
         if mAmp(m,n)==1
             A(m,n)=unifrnd(Ai-dAi,Ai+dAi,1,1);
         else
             A(m,n)=unifrnd(Aw-dAw,Aw+dAw,1,1);
         end;
     end;
 end;
 
dHw=0.1; dHi=0.05;	
z=zeros(M,N);
 
 for m=1:M		
     for n=1:N
         if mAmp(m,n)==1
             z(m,n)=unifrnd(Hi-dHi,Hi+dHi,1,1);
         else
             z(m,n)=unifrnd(0,dHw,1,1);
         end;
     end;
 end;
 

Nots=20; %chislo impulsov
Timp=0.000185; %period povtoreniya impulsov
x0=-1; %koordinata X LA 
y0=0; %koordinata Y LA
zkv=30.1; %visota pervoy antenni
zkn=29.9; %visota vtoroy antenni
k=1:Nots; %vichisleniye opornoy funkcii
xk=(x0+k); %traektoria po X
Rop(k)=sqrt(xk(1,k).^2+(y0-1000).^2+H0.^2);
hop(k)=exp((-1i.*4.*pi/lambda).*(Rop(k))); %opornaya funkcia 

for m=1:M 
   for n=1:N
        k=1:Nots;
        x(m,n)=x0+(n-1)*deltaLaz; %koordinati tochek poverhnosti
        y(m,n)=D0+(m-1)*deltaR;
        R1(n,k)=sqrt((xk(1,k)-x(m,n)).^2+(y0-y(m,n)).^2+(zkv-z(m,n)).^2); %verhnyaya antenna
        S1(n,k)=A(m,n).*exp((1i.*4.*pi/lambda).*R1(n,k)+1i.*fi(m,n));
        S1sum(m,k)=sum(S1(n,k));  
        R2(n,k)=sqrt((xk(1,k)-x(m,n)).^2+(y0-y(m,n)).^2+(zkn-z(m,n)).^2); %nignyaya antenna 
        S2(n,k)=A(m,n).*exp((1i.*4.*pi/lambda).*R2(n,k)+1i.*fi(m,n));
        S2sum(m,k)=sum(S2(n,k));   
        dR(n,k)=R1(n,k)-R2(n,k);
   end;
   
   for n=1:N
        k=1:Nots;
        A1(m,n)=sum(S1(n,k).*hop(k));
        A2(m,n)=sum(S2(n,k).*hop(k));
   end;
end;

alfa=(H0-z)/D0;


%obrabotka RLI 1
S1amp=abs(A1); %amplituda pervogo signala
S1faz=angle(A1); %faza pervogo signala

%obrabotka RLI 2
S2amp=abs(A2); %amplituda vtorogo signala
S2faz=angle(A2);%%faza vtorogo signala

%pereshet v visotu
raznf=S2faz-S1faz;%raznosti 
dfif=lambda*raznf/(2*pi*B);%ugol
hfinal=H0-D0.*sin(alfa);%visota reliefa
str=S1amp(248,:)
% figure(1); surf(mAmp); grid on; colormap gray; title('Ice');
% figure(2); surf(A); grid on; colormap gray; title('Amplitude');
figure(3); plot(str); grid on; colormap gray; title('Razrez kanala dalnosti');
figure(4); imagesc(S1amp); grid on; colormap gray; title('Amplitude RLI');
figure(5); imagesc(hfinal); grid on; colormap winter; title('Visotnoye RLI');
sredz=mean(z)
sredh=mean(hfinal)
sredfinal=sredz-sredh



    
