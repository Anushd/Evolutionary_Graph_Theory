%Generate complete graphs
num_nodes = 1:100;
template = ones(length(num_nodes),length(num_nodes));
complete_graphs = zeros(num_nodes(end),num_nodes(end)*num_nodes(end));
for j = 1:num_nodes(end)
    tmp = template;
    for i=1:j
        tmp(i,i) = 0; 
    end
    if j~=num_nodes(end)
        tmp(j+1:end,:) = 0;
        tmp(:,j+1:end) = 0;
    end

    tmp=tmp(:);

    complete_graphs(j,:) = tmp;
end

complete_graphs(1:2,:) = [];

lab=[];
for i=3:num_nodes(end)
    lab=[lab,1/i];
end

mdl = TreeBagger(100,complete_graphs,lab,'Method','regression','OOBPredictorImportance','on');

y=[];
for i=1:98
    y = [y,predict(mdl,complete_graphs(i,:))];
end

plot(3:100,y)
hold on
plot(3:100,lab)
