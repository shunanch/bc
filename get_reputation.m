function [reputation] = get_reputation(bid_id,matrix_bid,matrix_agent,timeslot)
    bid_id_col = matrix_bid(:,1);
    agent_id = matrix_bid(bid_id_col == bid_id,7);
    timeslot_col = matrix_agent(:,5);
    agent_id_curr = matrix_agent(timeslot_col == timeslot,1);
    reputation = matrix_agent(agent_id_curr == agent_id,4);
end
