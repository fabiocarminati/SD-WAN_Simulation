function[total_number_of_packets number_of_decoded_packets]=decoded_packets(node_name, generation_size, redundant_packets_per_generation, node_generation_rank_matrix)
number_of_decoded_generations = 0;
expected_rank = generation_size-redundant_packets_per_generation;
[number_of_generations col] = size(node_generation_rank_matrix);
total_number_of_packets = number_of_generations * expected_rank;
decoded_pattern = [];
for n = 1:1:number_of_generations
    if node_generation_rank_matrix(n,2) == expected_rank
        add = ones(1,expected_rank);
        number_of_decoded_generations = number_of_decoded_generations + 1;
    else
        add = zeros(1,expected_rank);
    end
    decoded_pattern = [decoded_pattern add];
end
number_of_decoded_packets = number_of_decoded_generations * expected_rank;
filename = strcat(node_name, '_recieved_packet_pattern.txt');
fid = fopen(filename,'w');
fprintf(fid, '%d ', decoded_pattern);
fclose(fid);
end