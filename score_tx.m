function [score] = score_tx(matrix_tx,matrix_bid,matrix_agent,timeslot)
%paramaters of scoring function
a = 0.6;
b = 0.2;
c = 0.2;
tx_num = size(matrix_tx,1);
score_pq = 0;
score_stf = 0;
score_tx_num = 0;
for i = 1:tx_num
    bid_buy_id = matrix_tx(i,2);
    bid_sell_id = matrix_tx(i,3);
    matched_price = matrix_tx(i,4);
    matched_quantity = matrix_tx(i,5);
    stf = matrix_tx(i,8);
    buy_r = get_reputation(bid_buy_id,matrix_bid,matrix_agent,timeslot);
    sell_r = get_reputation(bid_sell_id,matrix_bid,matrix_agent,timeslot);
    tx_r = buy_r * sell_r;
    score_pq = score_pq + matched_price*matched_quantity*tx_r;
    score_stf = score_stf + stf*tx_r;
    score_tx_num = score_tx_num + tx_r;
end
score = a*score_pq + b*score_tx_num + c*score_stf;
end

