%Программа для пересчета координат из геоцентрической системы в геодезическую


%координаты потребителя в геоцетрической системе координат
%X = input('Vvedite X: ');
%Y = input('Vvedite Y: ');
%Z = input('Vvedite Z: ');
X=2861525
Y=2195280
Z=5242989 
%Ѕольша€ полуось эллипсоида
a=6378245;
%—жатие эллипсоида1
alpha=1/298.3;
%Ёксцентриситет эллипсоида
e2=2*alpha-alpha^2;
%¬спомогательна€ величина
D=sqrt(X^2+Y^2);
if D==0
    B=(pi/2)*(Z/abs(Z))
    L=0
    H=Z*sin(B)-a*sqrt(1-e2*(sin(B))^2)
else
    La=abs(asin(Y/D));
     if ((Y<0)&&(X>0));
        L=2*pi-La
     end
     if ((Y<0)&&(X<0));
        L=pi+La
     end
     if ((Y>0)&&(X<0));
        L=pi-La
     end
     if ((Y>0)&&(X>0));
        L=La
     end
     if ((Y==0)&&(X>0));
        L=0
     end
     if ((Y==0)&&(X<0));
        L=pi
     end
end
if Z==0;
    B=0
    H=D-a
else
    %Ќайдем вспомогательные величины
    r=sqrt(X^2+Y^2+Z^2);
    c=asin(Z/r);
    p=(e2*a)/(2*r);
    s1=0;
    b=c+s1;
    s2=asin((p*sin(2*b)/(sqrt(1-e2*sin(b)^2))));
    d=abs(s2-s1)
    if d<10^-8    
        B=b
        H=D*cos(B)+Z*sin(B)-a*sqrt(1-e2*sin(B)^2);
    else
        while d>10^-8 
        s1=s2
        b=c+s1;
        s2=asin((p*sin(2*b)/sqrt(1-e2*sin(b)^2)));
        d=abs(s2-s1)
        end
        B=b
        H=D*cos(B)+Z*sin(B)-a*sqrt(1-e2*sin(B)^2);
    end
    B
    Bgrad=B*(180/pi)
    Bgrad2=(Bgrad-floor(Bgrad))*60
    Lgrad=L*(180/pi);
end
