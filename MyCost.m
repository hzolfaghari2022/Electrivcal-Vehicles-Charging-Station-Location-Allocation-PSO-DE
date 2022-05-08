function [z sol]=MyCost(xhat,model)

    sol=ParseSolution(xhat,model);

    w1=1;
    w2=1;
    beta=10;
    
    z=(w1*sol.SumOCR+w2*sol.SumXF)*(1+beta*sol.MeanCapV);

end