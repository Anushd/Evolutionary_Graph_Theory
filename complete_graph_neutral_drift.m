k = 4;
num_blocks = 2*(k-2);
blocks = cell(2,num_blocks/2);

for i=1:num_blocks/2
    mat = zeros(nchoosek(k,i),nchoosek(k,i+1));
    idx1 = combnk(1:k,i);
    idx2 = combnk(1:k,i+1);
    for j=1:length(idx1)
        tmp_idx=zeros(length(idx1),1);
        for l=1:length(idx2)
            memb = ismember(idx1(j,:),idx2(l,:));
            if all(memb)
                tmp_idx(l)=1;
            end
        end
        mat(j,find(tmp_idx)) = 1;
    end
    
    p = i/(k*(k-1));
    mat(mat~=0) = p;
    blocks{1,i} = mat;
    
    mat = transpose(mat);
    p = (k-(i+1))/(k*(k-1));
    mat(mat~=0) = p;
    blocks{2,i} = mat;
end

mat_size = 0;
block_coords = [];
for i=1:k-1
    mat_size = mat_size+nchoosek(k,i);
    if i==1
        block_coords = [block_coords, nchoosek(k,i)];
    else
        block_coords = [block_coords, block_coords(i-1)+nchoosek(k,i)];
    end
end
Q = zeros(mat_size,mat_size);

for i=1:(num_blocks/2)+1
    if i==1
        row = 1:block_coords(i);
    else
        row = block_coords(i-1)+1:block_coords(i);
    end
    
    if i<(num_blocks/2)+1
        col = block_coords(i)+1:block_coords(i+1);

        Q(row,col) = cell2mat(blocks(1,i));
        Q(col,row) = cell2mat(blocks(2,i));
    end
    
    diag = (1/(k*(k-1)))*(i*(i-1)+(k-i)*(k-i-1));
    for j=row
        Q(j,j) = diag;
    end
end

S = zeros(mat_size,2);
S(1:k) = 1/k;
S(end-k+1:end) = 1/k;
A = inv(eye(mat_size)-Q);
Q
A
A = A*S;
A(1,:)
