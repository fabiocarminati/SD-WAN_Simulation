clear
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%simulation performed in an abstracted network coding layer between network and transport layers
%adjacency matrix of the simulation network 
%     0 1 2 3 4 5 6
%
% 0   0 1 1 0 0 0 0
% 1   0 0 0 1 0 1 0
% 2   0 0 0 1 0 0 1
% 3   0 0 0 0 1 0 0
% 4   0 0 0 0 0 1 1
% 5   0 0 0 0 0 0 0
% 6   0 0 0 0 0 0 0
%simulation parameters
redundant_packets_per_generation = 1; %this is the number of redundant packet combinations per generation
field_size = 8; %The Galois field has 2^(field_size) number of elements
%network_code_rate = 1 - (redundant_packets_per_generation/generation_size);
generation_size = 10; %this is the total number of packet combinations per generation
link_loss_probability = 0.005; %packet loss probability per each link in the network
%included files only has link packet loss patterns for link_loss_probabilities of 0.0025, 0.005, 0.0075, 0.01, 0.0125 & 0.015
packets = 1000; %number of packets considered in the simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
largest = 2^field_size - 1;
fprintf('Simulation in progress...\n');
%initialising
%generate coefficients
coefficient_matrix = gf(round(rand((packets+10),(generation_size-redundant_packets_per_generation))*largest),field_size);
%generate generation_rank_matrix
number_of_generations = floor(packets/generation_size);
generation_rank_matrix = [transpose([1:1:number_of_generations]) zeros(number_of_generations,1)];
generation_received_matrix = [transpose([1:1:number_of_generations]) zeros(number_of_generations,1)];
generation = 1;
packet_number = 0;
generation_packet_number = 0;
%source
node0_output_packet_1_coefficients = [];
node0_output_packet_1_header = [];
node0_output_packet_2_coefficients = [];
node0_output_packet_2_header = [];
%intermediate nodes
node1_packet_coefficients = [];
node1_headers = [];
node1_output_packet_coefficients = [];
node1_output_packet_header = [];
node2_packet_coefficients = [];
node2_headers = [];
node2_output_packet_coefficients = [];
node2_output_packet_header = [];
node3_packet_coefficients = [];
node3_headers = [];
node3_output_packet_coefficients = [];
node3_output_packet_header = [];
node4_packet_coefficients = [];
node4_headers = [];
node4_output_packet_coefficients = [];
node4_output_packet_header = [];
%receivers
node5_packet_coefficients = [];
node5_headers = [];
node5_generation_rank_matrix = generation_rank_matrix;
node5_generation_received_matrix = generation_received_matrix;
node6_packet_coefficients = [];
node6_headers = [];
node6_generation_rank_matrix = generation_rank_matrix;
node6_generation_received_matrix = generation_received_matrix;
loss_gen_var = 0;
%links
link_0_1_output_packet_coefficients = [];
link_0_1_output_packet_header = [];
link_0_2_output_packet_coefficients = [];
link_0_2_output_packet_header = [];
link_1_3_output_packet_coefficients = [];
link_1_3_output_packet_header = [];
link_1_5_output_packet_coefficients = [];
link_1_5_output_packet_header = [];
link_2_3_output_packet_coefficients = [];
link_2_3_output_packet_header = [];
link_2_6_output_packet_coefficients = [];
link_2_6_output_packet_header = [];
link_3_4_output_packet_coefficients = [];
link_3_4_output_packet_header = [];
link_4_5_output_packet_coefficients = [];
link_4_5_output_packet_header = [];
link_4_6_output_packet_coefficients = [];
link_4_6_output_packet_header = [];
%generate link loss patterns
[loss_matrix_0] = loss_patterns(10, link_loss_probability);
[loss_matrix_1] = rotate_matrix(loss_matrix_0, 100);
[loss_matrix_2] = rotate_matrix(loss_matrix_0, 200);        
[loss_matrix_3] = rotate_matrix(loss_matrix_0, 300);        
loss_matrix = [loss_matrix_0; loss_matrix_1; loss_matrix_2; loss_matrix_3];
%link loss patterns
linkloss_0_1 = loss_matrix(1,:);
linkloss_0_2 = loss_matrix(2,:);
linkloss_1_3 = loss_matrix(3,:);        
linkloss_1_5 = loss_matrix(4,:);
linkloss_2_3 = loss_matrix(6,:);
linkloss_2_6 = loss_matrix(7,:);
linkloss_3_4 = loss_matrix(8,:);
linkloss_4_5 = loss_matrix(9,:);
linkloss_4_6 = loss_matrix(10,:);
loss_gen_var = 0;
while(packet_number < packets)
    %%%node operations%%%
    %node0(source)
    %transmits 2 packets per transmission attempt
    %generate packet 1
    [node0_output_packet_1_coefficients, node0_output_packet_1_header, generation_packet_number, generation_size, generation, packet_number, coefficient_matrix]=generate_output_packet(generation_packet_number, generation_size, generation, packet_number, coefficient_matrix);
    %generate packet 2
    [node0_output_packet_2_coefficients, node0_output_packet_2_header, generation_packet_number, generation_size, generation, packet_number, coefficient_matrix]=generate_output_packet(generation_packet_number, generation_size, generation, packet_number, coefficient_matrix);
    %node1(intermediate node)
    if isempty(node1_packet_coefficients) == 0
        [node1_output_packet_header, node1_output_packet_coefficients, node1_headers, node1_packet_coefficients] = node(2, node1_headers, node1_packet_coefficients, field_size);
    end
    %node2(intermediate node)
    if isempty(node2_packet_coefficients) == 0
        [node2_output_packet_header, node2_output_packet_coefficients, node2_headers, node2_packet_coefficients] = node(4, node2_headers, node2_packet_coefficients, field_size);
    end
    %node3(intermediate node)
    if isempty(node3_packet_coefficients) == 0
        [node3_output_packet_header, node3_output_packet_coefficients, node3_headers, node3_packet_coefficients] = node(2, node3_headers, node3_packet_coefficients, field_size);
    end
    %node4(intermediate node)
    if isempty(node4_packet_coefficients) == 0
        [node4_output_packet_header, node4_output_packet_coefficients, node4_headers, node4_packet_coefficients] = node(3, node4_headers, node4_packet_coefficients, field_size);
    end
    %node5(sink)
    if isempty(node5_packet_coefficients) == 0
        [node5_headers, node5_packet_coefficients, node5_generation_rank_matrix, node5_generation_received_matrix] = sink(node5_headers, node5_packet_coefficients, node5_generation_rank_matrix, node5_generation_received_matrix, field_size);
    end    
    %node6(sink)
    if isempty(node6_packet_coefficients) == 0
        [node6_headers, node6_packet_coefficients, node6_generation_rank_matrix, node6_generation_received_matrix] = sink(node6_headers, node6_packet_coefficients, node6_generation_rank_matrix, node6_generation_received_matrix, field_size);
    end
    %%%link operations%%%
    if loss_gen_var >= 1000
        loss_gen_var = 0;
    end
    loss_gen_var = loss_gen_var + 1;
    %Applying losses
    %link_0_1
    if linkloss_0_1(loss_gen_var) == 0
        link_0_1_output_packet_coefficients = [];
        link_0_1_output_packet_header = [];
    else
        link_0_1_output_packet_coefficients = node0_output_packet_1_coefficients;
        link_0_1_output_packet_header = node0_output_packet_1_header;
    end
    %link_0_2
    if linkloss_0_2(loss_gen_var) == 0
        link_0_2_output_packet_coefficients = [];
        link_0_2_output_packet_header = [];
    else
        link_0_2_output_packet_coefficients = node0_output_packet_2_coefficients;
        link_0_2_output_packet_header = node0_output_packet_2_header;
    end
    %link_1_3
    if linkloss_1_3(loss_gen_var) == 0
        link_1_3_output_packet_coefficients = [];
        link_1_3_output_packet_header = [];
    else
        if isempty(node1_output_packet_coefficients) == 0
        link_1_3_output_packet_coefficients = node1_output_packet_coefficients(1,:);
        link_1_3_output_packet_header = node1_output_packet_header(1,:);
        end
    end
    %link_1_5
    if linkloss_1_5(loss_gen_var) == 0
        link_1_5_output_packet_coefficients = [];
        link_1_5_output_packet_header = [];
    else
        if isempty(node1_output_packet_coefficients) == 0
        link_1_5_output_packet_coefficients = node1_output_packet_coefficients(2,:);
        link_1_5_output_packet_header = node1_output_packet_header(2,:);
        end
    end
    %link_2_3
    if linkloss_2_3(loss_gen_var) == 0
        link_2_3_output_packet_coefficients = [];
        link_2_3_output_packet_header = [];
    else
        if isempty(node2_output_packet_coefficients) == 0
        link_2_3_output_packet_coefficients = node2_output_packet_coefficients(1,:);
        link_2_3_output_packet_header = node2_output_packet_header(1,:);
        end
    end    
    %link_2_6
    if linkloss_2_6(loss_gen_var) == 0
        link_2_6_output_packet_coefficients = [];
        link_2_6_output_packet_header = [];
    else
        if isempty(node2_output_packet_coefficients) == 0
        link_2_6_output_packet_coefficients = node2_output_packet_coefficients(2,:);
        link_2_6_output_packet_header = node2_output_packet_header(2,:);
        end
    end
    %link_3_4
    if linkloss_3_4(loss_gen_var) == 0
        link_3_4_output_packet_coefficients = [];
        link_3_4_output_packet_header = [];
    else
        if isempty(node3_output_packet_coefficients) == 0
        link_3_4_output_packet_coefficients = node3_output_packet_coefficients(1,:);
        link_3_4_output_packet_header = node3_output_packet_header(1,:);
        end
    end
    %link_4_5
    if linkloss_4_5(loss_gen_var) == 0
        link_4_5_output_packet_coefficients = [];
        link_4_5_output_packet_header = [];
    else
        if isempty(node4_output_packet_coefficients) == 0
        link_4_5_output_packet_coefficients = node4_output_packet_coefficients(1,:);
        link_4_5_output_packet_header = node4_output_packet_header(1,:);
        end
    end
    %link_4_6
    if linkloss_4_6(loss_gen_var) == 0
        link_4_6_output_packet_coefficients = [];
        link_4_6_output_packet_header = [];
    else
        if isempty(node4_output_packet_coefficients) == 0
        link_4_6_output_packet_coefficients = node4_output_packet_coefficients(2,:);
        link_4_6_output_packet_header = node4_output_packet_header(2,:);
        end
    end
    %%%updating node input buffers according to how links are connected
    %%%between nodes%%%
    %node1
    node1_packet_coefficients = [node1_packet_coefficients; link_0_1_output_packet_coefficients];
    node1_headers = [node1_headers; link_0_1_output_packet_header];
    %node2
    node2_packet_coefficients = [node2_packet_coefficients; link_0_2_output_packet_coefficients];
    node2_headers = [node2_headers; link_0_2_output_packet_header];
    %node3
    node3_packet_coefficients = [node3_packet_coefficients; link_1_3_output_packet_coefficients; link_2_3_output_packet_coefficients];
    node3_headers = [node3_headers; link_1_3_output_packet_header; link_2_3_output_packet_header];
    %node4
    node4_packet_coefficients = [node4_packet_coefficients; link_3_4_output_packet_coefficients];
    node4_headers = [node4_headers; link_3_4_output_packet_header];
    %node5
    node5_packet_coefficients = [node5_packet_coefficients; link_1_5_output_packet_coefficients; link_4_5_output_packet_coefficients];
    node5_headers = [node5_headers; link_1_5_output_packet_header; link_4_5_output_packet_header];
    %node6
    node6_packet_coefficients = [node6_packet_coefficients; link_2_6_output_packet_coefficients; link_4_6_output_packet_coefficients];
    node6_headers = [node6_headers; link_2_6_output_packet_header; link_4_6_output_packet_header];
end
node5_generation_rank_matrix(end,:) = [];
node6_generation_rank_matrix(end,:) = [];
%output
clc
fprintf('Simulation complete.\n');
[node5_total_number_of_packets node5_number_of_decoded_packets]=decoded_packets('node5', generation_size, redundant_packets_per_generation, node5_generation_rank_matrix);
[node6_total_number_of_packets node6_number_of_decoded_packets]=decoded_packets('node6', generation_size, redundant_packets_per_generation, node6_generation_rank_matrix);
fprintf('Packet loss rate at node 5 = %f\n', ((node5_total_number_of_packets-node5_number_of_decoded_packets)/node5_total_number_of_packets));
fprintf('Packet loss rate at node 6 = %f\n', ((node6_total_number_of_packets-node6_number_of_decoded_packets)/node6_total_number_of_packets));