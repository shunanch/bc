     function matrix_tx = match(matrix_bid,matrix_agent,timeslot_num,miner_id)
%MATCH input bid_sheet，agent_sheet（reputation）
% output matrix_tx，
    [nRows_a, nCols_a] = size(matrix_agent);
    agent_property_num = nCols_a;
    agent_num = nRows_a/timeslot_num;
    [nRows_b,nCols_b] = size(matrix_bid);
    bid_property_num = nCols_b;
    bid_num = nRows_b/timeslot_num;
    %1.tx_id	2.bid_buy_id	3.bid_sell_id	4.matched_price	5.matched_quantity	6.timeslot	7.miner_id
matrix_tx = zeros(1,7);
for t = 1:timeslot_num
       buy_num  = sum(matrix_bid((t-1)*bid_num+1:t*bid_num,2) == 0);
       list_buy = matrix_bid((t-1)*bid_num+1:(t-1)*bid_num+buy_num,:);
       list_sell = matrix_bid((t-1)*bid_num+buy_num+1:t*bid_num,:);
       %Select the eligible sell_bid for buy_bid
       while size(list_buy,1) > 0
           %Randomly select the sell_bid, if the price is too high, then select up until there is no selection
           index_sell = randi([1, size(list_sell,1)], 1, 1);
           while index_sell >= 1
                if list_buy(1,4) < list_sell(index_sell,4)%Match failed, sell read up
                    index_sell = index_sell - 1;
                elseif list_buy(1,4) >= list_sell(index_sell,4)
                    %Match successfully, write into the tx matrix, jump out of the loop, set the index to -1, delete the corresponding buy bid and sell bid
                    matched_price = 0.5*(list_buy(1,4)+list_sell(index_sell,4));
                    matched_quantity = min(list_buy(1,3),list_sell(index_sell,3));
                    bid_buy_id = list_buy(1,1);
                    bid_sell_id = list_sell(index_sell,1);
                    timeslot = t;
                    %To calculate satisfaction, you need to get the original bid_price and price_sensitive
                    buy_price = list_buy(1,4);
                    buy_sensitive = list_buy(1,9);
                    sell_price = list_sell(index_sell,4);
                    sell_sensitive = list_sell(1,9);
                    satisfaction = sell_sensitive*(matched_price-sell_price) + buy_sensitive*(buy_price-matched_price);
                    if all(matrix_tx(:) == 0)
                        matrix_tx(1,2:8) = [bid_buy_id,bid_sell_id,matched_price,matched_quantity,timeslot,miner_id,satisfaction];
                    else
                        matrix_tx = cat(1,matrix_tx, [0,bid_buy_id,bid_sell_id,matched_price,matched_quantity,timeslot,miner_id,satisfaction]);
                    end
                    list_buy(1, :) = [];
                    list_sell(index_sell,:) = [];
                    index_sell = -1;
                end
           end
           if index_sell == 0 %If the match is unsuccessful, delete the corresponding buy bid
               list_buy(1, :) = [];
           end
       end
end
%Random number
tx_id = randi([10000, 99999], size(matrix_tx,1), 1);
matrix_tx(:, 1) = tx_id;
%miner id
%matrix_tx(:,7) = miner_id;
filename = sprintf('match_by_miner_%d.xlsx',miner_id);
writetable(array2table(matrix_tx), filename);

end

