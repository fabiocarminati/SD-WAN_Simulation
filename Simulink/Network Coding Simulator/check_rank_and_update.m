function[node_generation_rank_matrix]=check_rank_and_update(considered_generation, node_headers, node_packet_coefficients, node_generation_rank_matrix)
[number_of_packets_in_buffer, generation_size] = size(node_packet_coefficients);
generations = node_headers;
considered_generation_coefficients = [];
%get the combinations from the current_generation to a seperate matrix
for n = 1:1:number_of_packets_in_buffer
    if generations(n) == considered_generation
        %put the packet in to considered_generation_coefficients matrix
        considered_generation_coefficients = [considered_generation_coefficients; node_packet_coefficients(n,:)];
    end
end
considered_generation_rank = rank(considered_generation_coefficients);
[number_of_generations col] = size(node_generation_rank_matrix);
for n=1:1:number_of_generations
    if node_generation_rank_matrix(n,1) == considered_generation
        if considered_generation_rank > node_generation_rank_matrix(n,2)
            node_generation_rank_matrix(n,2) = considered_generation_rank;
        end
        break;
    end
end
end
