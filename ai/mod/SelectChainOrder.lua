--- OnSelectChainOrder() ---
--
-- Called when AI can select a chain order
-- 
-- Parameters:
-- cards = table of chain cards to select
--
-- Return: 
-- result = table containing card indices

function OnSelectChainOrder(cards)
print("OnSelectChainOrder: " .. #cards )
AI.Chat("OnSelectChainOrder: " .. #cards )
	for i=1,#cards do
		print(cards[i].id)
		AI.Chat(cards[i].id)
	end




----

	local result = {}
	local d = DeckCheck()
  if d and d.ChainOrder then
    result = d.ChainOrder(cards)
  end
  if result and #result>0 then
    return result
  end
  result = HEROChainOrder(cards) 
  if result and #result>0 then
    return result
  end
  result = {}
	-- Example implementation: pick the same order as the cards
	for i=1,#cards do
		result[i]=i
	end
	return result
end