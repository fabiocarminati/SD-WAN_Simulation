function[node_output_packet_coefficients, node_output_packet_header, generation_packet_number, generation_size, generation, packet_number, coefficient_matrix]=generate_output_packet(generation_packet_number, generation_size, generation, packet_number, coefficient_matrix)
if generation_packet_number > generation_size
    error('Error');
elseif generation_packet_number == generation_size
    generation_packet_number = 0;
    generation = generation + 1;
end
packet_number = packet_number + 1;
generation_packet_number = generation_packet_number + 1;
node_output_packet_coefficients = coefficient_matrix(packet_number,:);
node_output_packet_header = [generation];
end