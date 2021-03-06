clear all,clc,close all

%====Specify run directory ===================================

caso=menu('Select a wave type','Stationary','Progresive');
if caso==1
    load Caso5.mat;beachX=[0 30 30 0];ho=0.6;%H=0.15 m; T=2 s; h=0.6 m
    elseif caso==2
    load Caso6.mat;beachX=[0 30 30 0];ho=0.6;%H=0.075 m; T=2 s; h=0.6 m
    
end

%Introduce coordenadas de la particula
% P1X=input('Location x of particle 1:');%Ejemplo: 16.87
% P1Z=input('Location z of particle 1:');%Ejemplo: 0.3
P1X=16.87;
P1Z=.3;
%Encuentra indice de las posiciones que corresponden a los indices
idx=find(xc>P1X, 1 );
idx0=idx;

idy=find(yc>P1Z, 1 );
idy0=idy;

%Extrae serie temporal de la matriz tridimensional de las componentes de la
%velocidad
U1(:)=U(idy,idx,:);
W1(:)=W(idy,idx,:);




E=2;%Cambiar a E=1 si se utiliza Euler para el movimiento de la part�cula


dt=0.1;
water=[0 0 1];
i0=1;
X(i0)=xc(idx);
Y(i0)=yc(idy);




%idxUNaN=find(isnan(U)==1);
%idxWNaN=find(isnan(W)==1);
idxUNaN=isnan(U)==1;
idxWNaN=isnan(W)==1;
U(idxUNaN)=0;
W(idxWNaN)=0;

for i=1:1000
Xo=xc(idx);Yo=yc(idy);

%Calcula posiciond de la particula a partir del campo de velocidades
%utilizando Euler o Euler modificado
if E==1
%Euler method
    X(i+1)=Xo+dt.*U(idy(1),idx(1),i);
    Y(i+1)=Yo+dt.*W(idy(1),idx(1),i);

    
    
    idx=find(abs(xc-X(i+1))==min(abs(xc-X(i+1))), 1 );
    idy=find(abs(yc-Y(i+1))==min(abs(yc-Y(i+1))), 1 );


else
%Modified Euler method
    Xpred=Xo+dt.*U(idy(1),idx(1),i);
    Ypred=Yo+dt.*W(idy(1),idx(1),i);
    
    
    idxpred=find(abs(xc-Xpred)==min(abs(xc-Xpred)), 1 );
    idypred=find(abs(yc-Ypred)==min(abs(yc-Ypred)), 1 );

    Upred=U(idypred(1),idxpred(1),i);
    Wpred=W(idypred(1),idxpred(1),i);

    Ua=0.5.*(Upred+U(idy(1),idx(1),i));
    Wa=0.5.*(Wpred+W(idy(1),idx(1),i));
    X(i+1)=Xo+dt.*Ua;
    Y(i+1)=Yo+dt.*Wa;
    idx=find(abs(xc-X(i+1))==min(abs(xc-X(i+1))), 1 );
    idy=find(abs(yc-Y(i+1))==min(abs(yc-Y(i+1))), 1 );
    
    

    
end

%Grafica canal y series temporales de superficie libre, u y w
    subplot(4,1,1:2)
 
    fill([xc(1) xc' xc(end)],[0 eta(i,:) 0], water),hold on
    if(i>=400)
     %plot(X(i-20:i),Y(i-20:i),'r')
    h=plot(xc(idx),yc(idy),'ow')
    set(h,'MarkerFaceColor','r')
    else
        h=plot(Xo,Yo,'ow')
        set(h,'MarkerFaceColor','r')
    end


    plot([xc(idx0) xc(idx0)],[ho-0.1 ho+0.20],'k','LineWidth',3)
    text(xc(idx0)+0.5,0.75,'WG1')

    
    td=title(['t= ' num2str(i*dt) ' s'],'fontsize',12,'color','black');
    
    xlabel('Along-flume distance (m)')
    ylabel('Elevation (m)')

    set(gca,'FontSize',14)
    axis([xc(idx0)-3 xc(idx0)+3 0 0.80])
        set(gca,'LineWidth',2)

    hold off
    
    subplot(4,1,3)
    
    plot(time(1:i+1),eta(1:i+1,idx0)-ho,'k'),hold on
    axis([time(i+1)-20 time(i+1) -0.15 0.15]),hold off
    xlabel('Time (s)'),ylabel('\eta (m)')
    set(gca,'FontSize',14)    
    set(gca,'LineWidth',2)

    
    subplot(4,1,4)
    
    [AX,H1,H2]=plotyy(time(1:i+1),U1(1:i+1),time(1:i+1),W1(1:i+1));




set(get(AX(1),'Ylabel'),'String','u (m/s)','FontSize',14)
set(get(AX(2),'Ylabel'),'String','w (m/s)','FontSize',14)

set(AX(1),'YColor','r')
set(AX(2),'YColor','b')
set(H1,'Color','r')
set(H2,'Color','b')
set(H1,'LineWidth',2)
set(H2,'LineWidth',1)
set(AX(1),'FontSize',14)
set(AX(2),'FontSize',14)
set(AX(1),'LineWidth',2)
set(AX(2),'LineWidth',2)

set(AX(1),'YLim',[-0.2 0.2])
set(AX(2),'YLim',[-0.2 0.2])
set(AX(1),'XLim',[time(i+1)-20 time(i+1)])
set(AX(2),'XLim',[time(i+1)-20 time(i+1)])


xlabel('Time (s)')

        set(gcf,'position',[0         0         994         737]) 

       drawnow

    
end

WG1=eta(:,idx0);

save Practica2.mat P1X P1Z WG1 U1 W1 X Y time

%Pruebas Gonzalo
for i=1:1000
    subplot(2,1,1)
    plot(time(1:i+1),eta(1:i+1,idx0)-ho,'b');
    %hold on;
    subplot(2,1,2)
    plot(time(1:i+1),eta2(1:i+1)-ho,'b');
    pause(.1);
end
subplot(2,1,1)
eta3=eta(:,idx0)-ho;
plot(time(:),eta(:,idx0)-ho);
subplot(2,1,2)
plot(time(:),eta2(:)-ho);