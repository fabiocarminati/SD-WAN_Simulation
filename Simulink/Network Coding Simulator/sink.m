function[node_headers, node_packet_coefficients, generation_rank_matrix, generation_received_matrix] = sink(node_headers, node_packet_coefficients, generation_rank_matrix, generation_received_matrix, field_size);
packet_number_in_buffer = 0;
[number_of_generations col] = size(generation_received_matrix);
[number_of_packets_in_buffer, generation_size] = size(node_packet_coefficients);
%check for the most recent generation
for n = 1:number_of_packets_in_buffer
    if n == 1
        current_generation = node_headers(1);
    elseif current_generation < node_headers(n)
        current_generation = node_headers(n);
    end
end
%flush packets belonging to older generations
for n = 1:number_of_packets_in_buffer
    packet_number_in_buffer = packet_number_in_buffer + 1;
    if node_headers(packet_number_in_buffer) == (current_generation - 2)
        %update the received number of packets matrix
        for l = 1:1:number_of_generations
            if generation_received_matrix(l,1) == (current_generation - 2)
                generation_received_matrix(l,2) = generation_received_matrix(l,2) + 1;
            end
        end
        %flush the packet information from buffer
        node_packet_coefficients = flush(node_packet_coefficients, packet_number_in_buffer, field_size);
        node_headers(packet_number_in_buffer,:) = [];
        packet_number_in_buffer = packet_number_in_buffer - 1;
    end
end
%check rank of current generation
considered_generation = current_generation;
if considered_generation > 0
    [generation_rank_matrix]=check_rank_and_update(considered_generation, node_headers, node_packet_coefficients, generation_rank_matrix);
end
%check rank of (current generation - 1) generation
considered_generation = current_generation - 1;
if considered_generation > 0
    [generation_rank_matrix]=check_rank_and_update(considered_generation, node_headers, node_packet_coefficients, generation_rank_matrix);
end
end