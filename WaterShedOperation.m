function xhat2=WaterShedOperation(xhat1)

    %Q=randi([1 5]);
    
    p=[8 8 10 5 5];
%     p =[20 20 50 40 30];
    p=p/sum(p);
    Q=RouletteWheelSelection(p);
    
    switch Q
        case 1
            xhat2=SwapRows(xhat1);
            
        case 2
            xhat2=SwapCols(xhat1);
            
        case 3
            xhat2=SwapElements(xhat1);
            
        case 4
            xhat2=SwapDiagElements(xhat1);
            
        case 5
            xhat2=ReverseDiagElements(xhat1);
    end

end


function xhat2=SwapRows(xhat1)

    N=size(xhat1,1);
    
    i=randsample(N,2);
    
    i1=i(1);
    i2=i(2);
    
    xhat2=xhat1;
    xhat2([i1 i2],:)=xhat1([i2 i1],:);

end

function xhat2=SwapCols(xhat1)

    N=size(xhat1,2);
    
    i=randsample(N,2);
    
    i1=i(1);
    i2=i(2);
    
    xhat2=xhat1;
    xhat2(:,[i1 i2])=xhat1(:,[i2 i1]);

end

function xhat2=SwapElements(xhat1)

    [M N]=size(xhat1);
    
    i=randi([1 M],1,2);
    j=randi([1 N],1,2);
    
    i1=i(1);
    j1=j(1);
    
    i2=i(2);
    j2=j(2);
    
    xhat2=xhat1;
    xhat2(i1,j1)=xhat1(i2,j2);
    xhat2(i2,j2)=xhat1(i1,j1);
    
end

function xhat2=SwapDiagElements(xhat1)

    N=size(xhat1,1);
    
    i=randsample(N,2);
    
    i1=i(1);
    i2=i(2);
    
    xhat2=xhat1;
    xhat2(i1,i1)=xhat1(i2,i2);
    xhat2(i2,i2)=xhat1(i1,i1);

end

function xhat2=ReverseDiagElements(xhat1)

    N=size(xhat1,1);
    
    i=randsample(N,2);
    
    i1=min(i);
    i2=max(i);
    
    xhat2=xhat1;
    
    A=i1:i2;
    B=i2:-1:i1;
    for k=1:numel(A)
        xhat2(A(k),A(k))=xhat1(B(k),B(k));
    end

end

