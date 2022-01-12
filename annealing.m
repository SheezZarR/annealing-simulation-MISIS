value=[50 40 30 50 30 24 36];
weight=[5 4 6 3 2 6 7];
TotalWeight=20;
beta=0:.1:1;                % various temperature coefficient
n=1000;

function X = Knapsack( value, weight, TotalWeight, beta, n )
    % Input: value = array of values associated with object i.
           % weight = array of weights associated with object i.
           % TotalWeight = the total weight one can carry in the knapsack.
           % beta = vector of beta values for simulated annealing.
           % n = number of simulations per beta value.
    % Output: FinalValue = maximum value of objects in the knapsack.
            % FinalItems = list of objects carried in the knapsack.
            % Entries in the vector correspond to object i
            % being present in the knapsack.
    
    v=length(value);
    W=zeros(1,v);                                % currently put items, 0 - not in the backpack, 1 - in backpack 
    Value=0;
    VW=0;                                        % history of all tried values for 1 currently observed temperature decrease speed
    a=length(beta);                              % amount of tests for each temperature shift
    nn=n*ones(1,a);                              % start temperature for 'a' amount of tests

    for i=1:a                                    % iterate through temperature coefficients
        b=beta(i);
        for j=2:nn(i)                            
            m=0;                                 % flag variable
            
            while m==0
                c=ceil(rand*v);                  % select random item 
                if W(c)==0 
                    m=1;
                end
            end
            
            TrialW=W;  
            TrialW(c)=1;                         % TrialW - backpack + 1 new item 

                                                 % randomly remove items until we are <= TotalWeight
            while sum(TrialW.*weight)>TotalWeight 
                e=0;                             % flag variable
                while e==0
                    d=ceil(rand*v);              % select random item 
                    if TrialW(d)==1 
                        e=1;
                    end
                end

                TrialW(d)=0;
            end

            
            f=sum(TrialW.*value)-sum(W.*value);  % Difference between old & current backpack's price
            g=min([1 exp(b*f)]);                 % possibility
            accept=(rand<=g);                    % rands - between 0 and 1;
            if accept                            % if accept within our 0 to 1 interval 
                W=TrialW;                        % update backpack with changed item selection
                VW(j)=sum(W.*value);             % current result fixated
            else                                 % if accept out of our 0 to 1 interval
                VW(j)=VW(j-1);                   % current result = previous
            end
        end
        Value=[Value VW(2:length(VW))];          % store the results of annealing for each temperature coefficient
        
    end

    FinalValue=Value(length(Value))
    x=0;
    for k=1:length(W)
        if W(k)==1
            x=[x k];
        end
    end
    FinalItems=x(2:length(x))
end

Knapsack( value, weight, TotalWeight, beta, n)
