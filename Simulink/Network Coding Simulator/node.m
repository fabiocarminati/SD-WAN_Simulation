function[node_output_packet_header, node_output_packet_coefficients, node_headers, node_packet_coefficients] = node(outputs, node_headers, node_packet_coefficients, field_size);
node_output_packet_header = [];
node_output_packet_coefficients = [];
current_generation_coefficients = [];
packet_number_in_buffer = 0;
[number_of_packets_in_buffer, generation_size] = size(node_packet_coefficients);
largest = 2^field_size - 1;
generations = node_headers;
%check for the oldest generation
for n = 1:number_of_packets_in_buffer
    if n == 1
        current_generation = generations(1);
    elseif current_generation < generations(n)
        current_generation = generations(n);
    end
end
%get the combinations from the current_generation to a matrix
%and flush them from the node buffer
for n = 1:number_of_packets_in_buffer
    packet_number_in_buffer = packet_number_in_buffer + 1;
    if generations(packet_number_in_buffer) == current_generation
        %put the packet in to current_matrix
        current_generation_coefficients = [current_generation_coefficients; node_packet_coefficients(packet_number_in_buffer,:)];
        current_matrix_header = node_headers(packet_number_in_buffer,:);
        %flush the packet information from buffer
        node_packet_coefficients = flush(node_packet_coefficients, packet_number_in_buffer, field_size);
        node_headers(packet_number_in_buffer,:) = [];
        packet_number_in_buffer = packet_number_in_buffer - 1;
    end
end
[number_of_packets_in_current_generation, generation_size] = size(current_generation_coefficients);
local_coding_vector = gf(round(rand(outputs,number_of_packets_in_current_generation)*largest),field_size);
for j = 1:1:outputs
    coding_vector = local_coding_vector(j,:);
    output_packet_coefficients = coding_vector*current_generation_coefficients;
    node_output_packet_header = [node_output_packet_header; current_matrix_header];
    node_output_packet_coefficients = [node_output_packet_coefficients; output_packet_coefficients];
end
end