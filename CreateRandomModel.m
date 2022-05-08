function model=CreateRandomModel(N)

    Pmin=ceil(0.15*N);
    Pmax=ceil(0.30*N);
    
    P=randi([Pmin Pmax]);

    Xmin=0;
    Xmax=100;
    X=randi([Xmin Xmax],1,N);
    
    Ymin=0;
    Ymax=100;
    Y=randi([Ymin Ymax],1,N);

    d=zeros(N,N);
    for i=1:N-1
        for j=i+1:N
            
            d(i,j)=sqrt((X(i)-X(j))^2+(Y(i)-Y(j))^2);
            
            d(j,i)=d(i,j);
            
        end
    end
    
    CostPerDistanceUnit=10;
    
    c=round(CostPerDistanceUnit*d);
    
    alpha=0.7;
    
    rmin=10;
    rmax=50;
    r=randi([rmin rmax],N,N);
    r=r-diag(diag(r));
    
    TotalR=sum(r(:));
    MeanCapacity=TotalR/P;
    MinCapacity=round(MeanCapacity);
    MaxCapacity=round(2*MeanCapacity);
    G=randi([MinCapacity MaxCapacity],1,N);
    
    rc=r.*c;
    SumRC=sum(rc(:));
    
    fmean=SumRC/P;
    fmin=round(0.8*fmean);
    fmax=round(1.2*fmean);
    f=randi([fmin fmax],1,N);
    
    model.N=N;
    model.P=P;
    model.X=X;
    model.Y=Y;
    model.d=d;
    model.c=c;
    model.alpha=alpha;
    model.r=r;
    model.f=f;
    model.G=G;
    
end