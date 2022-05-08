function PlotSolution(sol,model)

    N=model.N;
    X=model.X;
    Y=model.Y;

    x=sol.x;
    h=sol.h;
    
    xii=diag(x)';
    
    Hubs=find(xii==1);
    Clients=find(xii==0);
    
    for i=1:N
        plot([X(i) X(h(i))],[Y(i) Y(h(i))],'k--','LineWidth',2);
        hold on;
    end
    
    plot(X(Hubs),Y(Hubs),'kp',...
        'MarkerFaceColor','red',...
        'MarkerSize',16);
    
    plot(X(Clients),Y(Clients),'ks',...
        'MarkerFaceColor','green',...
        'MarkerSize',10);
    
    hold off;
    
    axis equal;

end