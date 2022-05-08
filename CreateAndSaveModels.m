function CreateAndSaveModels()

    N=[10 20 25 30 40 50 55 60 70 80 86 90 100];
    
    nProblem=numel(N);
    
    for k=1:nProblem
        
        model=CreateRandomModel(N(k));
        
        ModelName=['phlap_' num2str(model.N)];
        
        save(ModelName,'model');
        
    end

end