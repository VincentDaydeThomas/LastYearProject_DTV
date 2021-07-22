%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Reduce Temperature calculation program
%Version : 1.4
%Author : DAYDE-THOMAS Vincent
%Date of creation : 19/02/2021
%Last update :14/06/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Please read the Readme.txt in the folder 
%before begining using the program
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Admittance Method _ ISO 13786 and ISO 13790
%Murdoch and Levermore / Birtles and John  
%Begining of the program
%Cleaning
close all;
clear all;
%Reading data
load ('input.txt');
load ('air_properties.txt');
load ('general_informations.txt');
load ('input_ground.txt');
load ('input_roof.txt');
load ('windows_input.txt');
load ('results_simulation.txt');
load ('results_real.txt');
load ('temp_ext.txt');
load ('results_preheat_real.txt');
load ('temp_ext_preheat.txt');
load ('results_simulation_preheat.txt');
%Calculation Parameter P for calculation 
P1=24*3600; %Period (s)
m=1;   %If needed change this value to study harmonics
P=P1/m %If harmonical study not equal to 1
%%%Function of admittance Method for each component
function [k1,Up,phi,f]=admittance(rho,e,c,lambda,N,P,Rsi,Rso);
  Mi=[1 -Rsi; 0 1];
  Mo=[1 -Rso; 0 1];
  %Initialization Calculation Up
  R=Rsi+Rso;
  %Value assignation
  M2=[1 0; 0 1];
  %%%%Loop for building
  for j=1:N
    j;
    t(j)=((pi*e(j)*e(j)*rho(j)*c(j))/(P*lambda(j))).^(0.5);
    Z1=cosh(t(j)+i*t(j));
    Z2=-(e(j)*sinh(t(j)+i*t(j)))/(lambda(j)*(t(j)+i*t(j)));
    Z3=-((lambda(j)*(t(j)+i*t(j))*sinh(t(j)+i*t(j)))/e(j));
    Z4=cosh(t(j)+i*t(j));
    %test1=(e(j)*(exp(t)-exp(-t)));
    M1=[Z1 Z2;Z3 Z4];
    M2=M2*M1;
    %Calculation Up
    R=R+(e(j)/lambda(j));
  endfor
  %%Matrix calculation for building and CONTROL VALUES IF NECESSARY
  %Don't forget to add the control value to  the return value 
  %of function
  M=Mo*M2*Mi;
  Z12=M(1,2);
  Z11=M(1,1);
  Z22=M(2,2);
  Y11=-Z11/Z12; %Control value
  ABSY1=abs(Y11); %Control value
  ARGY1=P/(2*pi*3600)*arg(Y11); %Control value
  Y22=-Z22/Z12;  %Control value
  ABSY2=abs(Y22); %Control value
  ARGY2=P/(2*pi*3600)*arg(Y22); %Control value
  Up=1/(R);
  X=-1/(Z12*Up);
  Y12=-1/Z12;
  ABSY12=abs(Y12); %Control value
  ARGY12=P/(2*pi*3600)*arg(Y12);
  k1=(P/(2*pi))*abs((Z11-1)/Z12); %J/m2K %Internal
  k2=(P/(2*pi))*abs((Z22-1)/Z12); %J/m2K %External
  k1KJ=(P/(2*pi))*abs((Z11-1)/Z12)/1000; %kJ/m2K %Control value
  k2KJ=(P/(2*pi))*abs((Z22-1)/Z12)/1000; %kJ/m2K %Control value  
  %Calculation final parameters for building
  phi=ARGY12;
  f=abs(X);
endfunction
%%%For the building
rho=input(:,1);
e=input(:,2);
lambda=input(:,3);
c=input(:,4);
N=length(rho);
Rsi=0.13;
Rso=0.04;
[k1,Up,phi,f]=admittance(rho,e,c,lambda,N,P,Rsi,Rso);
k1_b=k1;
Up_b=Up;
phi_b=phi; 
f_b=f;
%%%For the windows
rho=windows_input(:,1);
e=windows_input(:,2);
lambda=windows_input(:,3);
c=windows_input(:,4);
N=length(rho);
Rsi=0.13;
Rso=0.04;
[k1,Up,phi,f]=admittance(rho,e,c,lambda,N,P,Rsi,Rso);
k1_w=k1;
Up_w=Up;
phi_w=phi; 
f_w=f;
%%%For the ground
rho=input_ground(:,1);
e=input_ground(:,2);
lambda=input_ground(:,3);
c=input_ground(:,4);
N=length(rho);
Rsi=0.13;
Rso=0; %Because of no air layer between the bottom of building and the ground
[k1,Up,phi,f]=admittance(rho,e,c,lambda,N,P,Rsi,Rso);
k1_g=k1;
Up_g=Up;
phi_g=phi; 
f_g=f;
%%%For the roof
rho=input_roof(:,1);
e=input_roof(:,2);
lambda=input_roof(:,3);
c=input_roof(:,4);
N=length(rho);
Rsi=0.13;
Rso=0.04;
[k1,Up,phi,f]=admittance(rho,e,c,lambda,N,P,Rsi,Rso);
k1_f=k1;
Up_f=Up;
phi_f=phi; 
f_f=f;
%Declaration of general informations 
S=general_informations(1); %floor surface
H=general_informations(2); %Height of a floor
NF=general_informations(3); %Number of floor
Perimeter=general_informations(4);  %Perimeter of all walls
S_w=general_informations(5); % Percentage of windows surface on lateral walls 
%%%%%%Part of the program for time constant
rho_a=air_properties(1);
c_a=air_properties(2);
q_a=air_properties(3);
bve_k=1;%Value of the adjustment factor (if the building is not stick to an another building, it is equal to 1)
%Overall ventilation heat transfer coefficient
Hveadj=rho_a*c_a*bve_k*q_a;
%Internal heat capacity of the building 
Ai_b=Perimeter*NF*H*(1-(S_w/100)); 
Ai_w=Perimeter*NF*H*(S_w/100);
Ai_g=S;
Ai_f=S;
Cm=(k1_b*Ai_b)+(k1_w*Ai_w)+(k1_g*Ai_g)+(k1_f*Ai_f);
%Overall transmission heat transfer coefficient
btr_d=1;
btr_g=1;
btr_u=1;
btr_a=1;
Hd=btr_d*(Up_b*Ai_b);
Hg=btr_g*0;
Hu=btr_u*0;
Ha=btr_a*0;
Htradj=Hd+Hg+Hu+Ha;
%Building time constant of the entire system
tau=(Cm/3600)/(Htradj+Hveadj) %Good value in hour
tau_i=int32(tau);%Transformation into integer variable
%%%%%Part for the preheat calculation
Q=general_informations(6)
T_confort=general_informations(7)
T_reduit=general_informations(8)
T_ext=general_informations(9)
%Calculation of drop time
T_ext=temp_ext(:,1);
npt=length(T_ext); %length of the datas
T_ext_mean=mean(T_ext); %mean value for the calculation
time_drop=-tau*log((T_reduit-T_ext_mean)/(T_confort-T_ext_mean))
%ti=zeros(1,npt);
T_drop=zeros(1,npt);
T_drop_non_corrected=zeros(1,npt);
for i=1:npt
  T_drop(i)=T_ext_mean+(T_confort-T_ext_mean)*exp(-i/tau);
  T_drop_corrected(i)=T_reduit+(T_confort-T_reduit)*exp(-i/tau);
endfor
%Calculation of the preheat time without adjustment
Conduc=Up_b*Ai_b+Up_f*Ai_f+Up_g*Ai_g+Up_w*Ai_w;%Thermal Conductance
time_preheat=tau*log((Q-Conduc*(T_reduit-T_ext_mean))/(Q-Conduc*(T_confort-T_ext_mean)))
%Calculation of the preheat time with adjustment
time_preheat=tau*log((Q-Conduc*(T_reduit-T_ext_mean))/(Q-Conduc*(T_confort-T_ext_mean)))
K_emp_adjust=0.82;   %Adjustment empirical factor
Q_adjust=Q*K_emp_adjust
time_preheat_adjust=tau*log((Q_adjust-Conduc*(T_reduit-T_ext_mean))/(Q_adjust-Conduc*(T_confort-T_ext_mean)))
%Calculation for preheat time
T_ext_preheat=temp_ext_preheat(:,1);
nptp=length(T_ext_preheat); %length of the datas
T_ext_preheat_mean=mean(T_ext_preheat); %mean value for the calculation
for j=1:nptp
  T_preheat_calc(j)=19;
  T_preheat_corr(j)=19;
endfor
j=1
while (T_preheat_calc<=19)
   T_preheat_calc(j)=T_ext_preheat_mean+(1/Conduc)*(Q-(Q-Conduc*(T_reduit-T_ext_preheat_mean))*exp(-j/tau));
   j=j+1;
endwhile
j=1  
while (T_preheat_corr<=19)
   T_preheat_corr(j)=T_ext_preheat_mean+(1/Conduc)*(Q_adjust-(Q_adjust-Conduc*(T_reduit-T_ext_preheat_mean))*exp(-j/tau));
   j=j+1;
endwhile 
%Figure 1 : Comparison with simulated and real datas for drop 
T_simu_drop=results_simulation(:,1);
T_real_drop=results_real(:,1);
figure(1)
hold on
plot(T_drop)
plot(T_simu_drop)
plot(T_real_drop)
plot(T_drop_corrected)
xlim([0 npt])
ylim([10 20])
ylabel('Temperature (°C)')
xlabel('Time (h)')
legend('1:T_{drop}','2:T_{simulated}','3:T_{real}','4:T_{drop with correction}')
title('Comparaison des évolutions de la chute de température _ COL098')
grid on
hold off
%Figure 2 : Comparison with simulated and real datas for preheat
T_real_preheat=results_preheat_real(:,1); 
T_sim_preheat=results_simulation_preheat(:,1);
figure(2)
hold on
plot(T_real_preheat)
plot(T_preheat_calc)
plot(T_sim_preheat)
plot(T_preheat_corr)
xlim([0 nptp])
ylim([10 20])
ylabel('Temperature (°C)')
xlabel('Time (h)')
legend('1:T_{real}','2:T_{preheat}','3:T_{simulated}','4:T_{preheat with correction}')
title('Comparaison des évolutions de la remontée en température _ COL098')
grid on
hold off
%Saving the data in a text file Results
save("Results.txt", "f_b", "phi_b", "tau", "time_preheat")
%End of the program