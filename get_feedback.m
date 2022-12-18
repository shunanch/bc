function [feedback] = get_feedback(bid_id,matrix_bid)
    bid_id_col = matrix_bid(:,1);
    feedback = matrix_bid(bid_id_col == bid_id,5);
end

