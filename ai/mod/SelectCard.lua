--- OnSelectCard ---
--
-- Called when AI has to select a card. Like effect target or attack target
-- Example card(s): Caius the Shadow Monarch, Chaos Sorcerer, Elemental HERO The Shining
-- 
-- Parameters:
-- cards = table of cards to select
-- minTargets = how many you must select min
-- maxTargets = how many you can select max
-- triggeringID = id of the card that is responsible for the card selection
--
-- Return: 
-- result = table containing target indices


function OnSelectCard(cards, minTargets, maxTargets, triggeringID,triggeringCard)
local result = {}
--[combo mode]
if combo then
--[]
AI.Chat("on select : ".. ob1 .." - ".. ob2 .. " ")
  print("on select : ".. ob1 .." - ".. ob2 .. " ")
  
  
-----
if not COMMAND_OHNKYTA_GLOBAL and triggeringID then 
gid=triggeringID
elseif COMMAND_OHNKYTA_GLOBAL == 5 then
gid=GlobalActivatedCardID
elseif COMMAND_OHNKYTA_GLOBAL == 0 then
gid=GlobalSummonedCardID
elseif COMMAND_OHNKYTA_GLOBAL == 1 then
gid=GlobalSSCardID

end
  
 --[[ selct certain cardgroups from cards ]] 
 if ids and ( #ids > 0 ) then 
 print(" selct certain cardgroups from cards ")
 if not selct then 
 print("no selct ? ")
  selct=0 
 end
 print(" selct is : " .. selct)
 --error
 print(" ids has " .. #ids .. " scs .")
  local scs=ids[selct+1]
 
  -- if #ids == 1 then
    -- cs=ids
  -- end 
   
  -- if #cs == 0 then 
   -- break
  -- end 
  
  local kk=#scs
 print("kk is : " .. kk )

-- [[for each ids[j] , loop in cards[i] and match it ]]
local slct=0

for j=1,#scs do 
 
 for i=1,#cards do
 
  if slct == j then 
   break
  end
  
  if cards[i].id == scs[j] then 
   print(cards[i].id .. " selected ! ")
   result[#result+1]=i
   slct=slct+1
   break
  end

 end 
 print(slct .. " cards have been selected . ")
end

   selct=selct+1
   return result
 end

-----above...
 
  ---- select one card from cards
-----  
 
 if idb and idb == 0 then
    AI.Chat(gid .. " selected : ".. cards[1].id )
    print(gid .. " selected : ".. cards[1].id )
  return {1}
 end 
 
if selct == 0 then 
  for i=1,#cards do 
  AI.Chat("cards[i].id : ".. cards[i].id )
  print("cards[i].id : ".. cards[i].id )
  
   if cards[i].id == idb then
   AI.Chat(gid .. " selected : ".. cards[i].id )
    print(gid .. " selected : ".. cards[i].id )
	selct=selct+1

	return {i}
   end
   
  end
---- 
 AI.Chat(" cardB not founded ")
 print(" cardB not founded ")
end 
if selct == 1 then 
 if idc and idc == 0 then
    AI.Chat(gid .. " selected : ".. cards[1].id )
    print(gid .. " selected : ".. cards[1].id )
  return {1}
 end 
  
  for i=1,#cards do 
  AI.Chat("cards[i].id : ".. cards[i].id )
  print("cards[i].id : ".. cards[i].id )
   if cards[i].id == idc then
   AI.Chat(gid .. " selected : ".. cards[i].id )
    print(gid .. " selected : ".. cards[i].id )
	selct=selct+1

	return {i}
   end
   
  end
  AI.Chat(" cardC not founded ")
 print(" cardC not founded ")

end
 

-----
 end 
--[crack mode]
if mode_crack then
print("OnSelectCard","in crack mode...")
end
-----  
  
  
  
  
  
-----
  
  

  --------------------------------------------
  -- Reset these variable if it gets this far.
  --------------------------------------------
  GlobalActivatedCardID = nil
  GlobalCardMode = nil
  GlobalAIIsAttacking = false
  GlobalSSCardID = nil
  GlobalSSCardSetcode = nil
  
  
  if triggeringID == 0 and not triggeringCard
  and Duel.GetTurnPlayer()==player_ai
  and Duel.GetCurrentPhase()==PHASE_END 
  and minTargets==maxTargets and minTargets == #AIHand()-6
  and LocCheck(cards,LOCATION_HAND,true)
  then
    --probably end phase discard
    return Add(cards,PRIO_TOGRAVE,minTargets)
  end
  
  
  -- always choose the mimimum amount of targets and select random targets
  local targets = {}
  for i,c in pairs(cards) do
    targets[i]=c
    c.index=i
  end
  for i=1,minTargets do
    local r=math.random(1,#targets)
    local c=targets[r]
    table.remove(targets,r)
    result[i]=c.index
  end

  return result 
end

