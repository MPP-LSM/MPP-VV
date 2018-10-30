function new_data = add_whitespace_padding(data)

nmax = 0;

for ii = 1:length(data)
    nmax = max([nmax length(data{ii})]);
end

for ii = 1:length(data)
    new_data{ii} = data{ii};
    for jj = 1:nmax-length(data{ii})
        new_data{ii} = [new_data{ii} ' '];
    end
end

    