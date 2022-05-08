clc;
clear;
close all;

%% Problem Definition

model=SelectModel();                        % Select Model

CostFunction=@(xhat) MyCost(xhat,model);    % Cost Function

VarSize=[model.N model.N];      % Decision Variables Matrix Size

nVar=prod(VarSize);             % Number of Decision Variables

VarMin=0;          % Lower Bound of Decision Variables
VarMax=1;          % Upper Bound of Decision Variables


%% PSO Parameters

MaxIt=500;      % Maximum Number of Iterations

nPop=200;        % Population Size (Swarm Size)

w=0.4;              % Inertia Weight
wdamp=1;            % Inertia Weight Damping Ratio
c1=0.3;             % Personal Learning Coefficient
c2=0.9;             % Global Learning Coefficient

% Constriction Coefficients
% phi1=2.05;
% phi2=2.05;
% phi=phi1+phi2;
% chi=2/(phi-2+sqrt(phi^2-4*phi));
% w=chi;          % Inertia Weight
% wdamp=1;        % Inertia Weight Damping Ratio
% c1=chi*phi1;    % Personal Learning Coefficient
% c2=chi*phi2;    % Global Learning Coefficient

% Velocity Limits
VelMax=0.1*(VarMax-VarMin);
VelMin=-VelMax;

%% Initialization

empty_particle.Position=[];
empty_particle.Cost=[];
empty_particle.Sol=[];
empty_particle.Velocity=[];
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];
empty_particle.Best.Sol=[];

particle=repmat(empty_particle,nPop,1);

BestSol.Cost=inf;

for i=1:nPop
    
    % Initialize Position
    particle(i).Position=unifrnd(VarMin,VarMax,VarSize);
    
    % Initialize Velocity
    particle(i).Velocity=zeros(VarSize);
    
    % Evaluation
    [particle(i).Cost particle(i).Sol]=CostFunction(particle(i).Position);
    
    % Update Personal Best
    particle(i).Best.Position=particle(i).Position;
    particle(i).Best.Cost=particle(i).Cost;
    particle(i).Best.Sol=particle(i).Sol;
    
    % Update Global Best
    if particle(i).Best.Cost<BestSol.Cost
        
        BestSol=particle(i).Best;
        
    end
    
end

BestCost=zeros(MaxIt,1);


%% PSO Main Loop

for it=1:MaxIt
    
    for i=1:nPop
        
        % Update Velocity
        particle(i).Velocity = w*particle(i).Velocity ...
            +c1*rand(VarSize).*(particle(i).Best.Position-particle(i).Position) ...
            +c2*rand(VarSize).*(BestSol.Position-particle(i).Position);
        
        % Apply Velocity Limits
        particle(i).Velocity = max(particle(i).Velocity,VelMin);
        particle(i).Velocity = min(particle(i).Velocity,VelMax);
        
        % Update Position
        particle(i).Position = particle(i).Position + particle(i).Velocity;
        
        % Velocity Mirror Effect
        IsOutside=(particle(i).Position<VarMin | particle(i).Position>VarMax);
        particle(i).Velocity(IsOutside)=-particle(i).Velocity(IsOutside);
        
        % Apply Position Limits
        particle(i).Position = max(particle(i).Position,VarMin);
        particle(i).Position = min(particle(i).Position,VarMax);
        
        % Evaluation
        [particle(i).Cost particle(i).Sol] = CostFunction(particle(i).Position);
        
        % WaterShedOperation
        for k=1:5
            NewParticle=particle(i);
            NewParticle.Position=WaterShedOperation(particle(i).Position);
            [NewParticle.Cost NewParticle.Sol]=CostFunction(NewParticle.Position);
            if NewParticle.Cost<=particle(i).Cost
                particle(i)=NewParticle;
            end
        end
        
        % Update Personal Best
        if particle(i).Cost<particle(i).Best.Cost
            
            particle(i).Best.Position=particle(i).Position;
            particle(i).Best.Cost=particle(i).Cost;
            particle(i).Best.Sol=particle(i).Sol;
            
            % Update Global Best
            if particle(i).Best.Cost<BestSol.Cost
                
                BestSol=particle(i).Best;
                
            end
            
        end
        
    end
    
    % Local Search based on WaterShedOperation
    for k=1:5
        NewParticle=BestSol;
        NewParticle.Position=WaterShedOperation(BestSol.Position);
        [NewParticle.Cost NewParticle.Sol]=CostFunction(NewParticle.Position);
        if NewParticle.Cost<=BestSol.Cost
            BestSol=NewParticle;
        end
    end

    BestCost(it)=BestSol.Cost/1.8;
    
    if BestSol.Sol.IsFeasible
        FLAG=' *';
    else
        FLAG='';
    end
    
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it)) FLAG]);
    
    w=w*wdamp;
    
    % Plot Best Solution
    figure(1)
    pause(0.1);
    PlotSolution(BestSol.Sol,model)
    
end

%% Results

figure
plot(BestCost,'LineWidth',2)
xlabel('Iteration');
ylabel('Best Cost');
disp(['                   ' num2str(size(BestSol.Sol.Hubs,2))])

