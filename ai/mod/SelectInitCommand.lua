--- OnSelectInitCommand() ---
--
-- Called when the system is waiting for the AI to play a card.
-- This is usually in Main Phase or Main Phase 2
-- 
--
-- Parameters (3):
-- cards = a table containing all the cards that the ai can use
-- 		cards.summonable_cards = for normal summon
-- 		cards.spsummonable_cards = for special special summon
-- 		cards.repositionable_cards = for changing position
-- 		cards.monster_setable_cards = monster cards for setting
-- 		cards.st_setable_cards = spells/traps for setting
-- 		cards.activatable_cards = for activating
-- to_bp_allowed = is entering battle phase allowed?
-- to_ep_allowed = is entering end phase allowed?
--
--[[
Each "card" object has the following fields:
card.id
card.original_id --original ----printed card id. Example: Elemental HERO Prisma can change id, but the original_id will always be 89312388
card.type --Refer to /script/constant.lua for a list of card types
card.attack
card.defense
card.base_attack
card.base_defense
card.level
card.base_level
card.rank
card.race --monster type
card.attribute
card.position
card.setcode --indicates the archetype
card.location --Refer to /script/constant.lua for a list of locations
card.xyz_material_count --number of material attached
card.xyz_materials --table of cards that are xyz material
card.owner --1 = AI, 2 = player
card.status --Refer to /script/constant.lua for a list of statuses
card:is_affected_by(effect_type) --Refer to /script/constant.lua for a list of effects
card:get_counter(counter_type) --Checks how many of counter_type this card has. Refer to /strings.conf for a list of counters

Sample usage

if card:is_affected_by(EFFECT_CANNOT_CHANGE_POSITION) then
	--this card cannot change position
end
if card:is_affected_by(EFFECT_CANNOT_RELEASE) then
	--this card cannot be tributed
end
if card:is_affected_by(EFFECT_DISABLE) or card:is_affected_by(EFFECT_DISABLE_EFFECT) then
	--this card's effect is currently negated
end

if card:get_counter(0x3003) > 0 then
	--this card has bushido counters
end

if(cards.activatable_cards[i].xyz_material_count > 0) then
local xyzmat = cards.activatable_cards[i].xyz_materials
	for j=1,#xyzmat do
		----print("material " .. j .. " = " .. xyzmat[j].id)
	end
end


-- Return:
-- COMMAND_OHNKYTA_GLOBAL = the COMMAND_OHNKYTA_GLOBAL to execute
-- index = index of the card to use
-- 
-- Here are the available commands
]]
COMMAND_LET_AI_DECIDE  = -1
COMMAND_SUMMON         = 0
COMMAND_SPECIAL_SUMMON = 1
COMMAND_CHANGE_POS     = 2
COMMAND_SET_MONSTER    = 3
COMMAND_SET_ST         = 4
COMMAND_ACTIVATE       = 5
COMMAND_TO_NEXT_PHASE  = 6
COMMAND_TO_END_PHASE   = 7

requireoptional("ai.mod.submod")
GlobalBPAllowed = nil
function OnSelectInitCommand(cards, to_bp_allowed, to_ep_allowed)
  ------------------------------------------
  -- The first time around, it sets the AI's
  -- turn (only if the AI is playing first).
  ------------------------------------------
  if not player_ai then player_ai = 1 end -- probably puzzle mode, so player goes first
  set_player_turn(true)
  DeckCheck()
  GlobalAIIsAttacking = nil
  GlobalMaterial = nil
  ResetOncePerTurnGlobals()
  GlobalBPAllowed = to_bp_allowed
  SurrenderCheck()
  
  --------------------------------------------------
  -- Storing these lists of cards in local variables
  -- for faster access and gameplay.
  --------------------------------------------------
  local ActivatableCards = cards.activatable_cards
  local SummonableCards = cards.summonable_cards
  local SpSummonableCards = cards.spsummonable_cards
  local RepositionableCards = cards.repositionable_cards
  print("TURN :",Duel.GetTurnCount())
  print("PHASE :" , Duel.GetCurrentPhase())
  if LAST_TURN~=Duel.GetTurnCount() then
   LAST_TURN=Duel.GetTurnCount()
     --[minium cardid]
	find_min_cid()
	print("mincid",MIN_CID)
  end
if mode_crack then

  --[for log]
  local choice_l={}
  local selected_l={}
  --[had got decided]
  if (#choice_path >= choice_seq) and choice_path[choice_seq] then
    --[write the old docu to log, and return the decided choice]
	print("decided by ai!!")
	if 1 ~= 0 then 
	--[act]
    if #ActivatableCards > 0 then
	print("acts list")
     for i=1,#ActivatableCards do
      choice_l[#choice_l+1]={COMMAND_ACTIVATE,ActivatableCards[i].cardid - MIN_CID }
     end
    end
    --[spsm]
    if #SpSummonableCards > 0 then
	print("spsms list")
     for i=1,#SpSummonableCards do
      choice_l[#choice_l+1]={COMMAND_SPECIAL_SUMMON,SpSummonableCards[i].cardid - MIN_CID }
     end
    end
    --[summon]
    if #SummonableCards > 0 then
	print("sms list")
     for i=1,#SummonableCards do
      choice_l[#choice_l+1]={COMMAND_SUMMON,SummonableCards[i].cardid - MIN_CID }
     end
    end
    --[set ST]
    if #cards.st_setable_cards > 0 then
	print("sets list")
     for i=1,#cards.st_setable_cards do
      choice_l[#choice_l+1]={COMMAND_SET_ST,cards.st_setable_cards[i].cardid - MIN_CID }
     end
    end
    --[reposition]
    if #RepositionableCards > 0 then
	print("repositions list")
     for i=1,#RepositionableCards do
      choice_l[#choice_l+1]={COMMAND_CHANGE_POS,RepositionableCards[i].cardid - MIN_CID }
     end
    end
    --[set M]
    --[next phase]
    choice_l[#choice_l+1]={6,1}
    --[next turn]
    choice_l[#choice_l+1]={7,1}
	end
    
	--[add decided log, and select the decided one]
	print( choice_path[choice_seq][1][1],1)
    add_raw_log(choice_l, OHNKYTA_LOG_TABLE, choice_path[choice_seq], OHNKYTA_LOG_SINGLE)
	
    return choice_path[choice_seq-1][1][1],1
    --[]
   else
    --[a new scene]
	print("new scene!")
	print("3 #choice_path",#choice_path)
	if 1~=0 then 
    --[act]
    if #ActivatableCards > 0 then
	print("acts")
     for i=1,#ActivatableCards do
      choice_l[#choice_l+1]={COMMAND_ACTIVATE,ActivatableCards[i].cardid - MIN_CID }
     end
    end
    --[spsm]
    if #SpSummonableCards > 0 then
	print("spsms")
     for i=1,#SpSummonableCards do
      choice_l[#choice_l+1]={COMMAND_SPECIAL_SUMMON,SpSummonableCards[i].cardid - MIN_CID }
     end
    end
    --[summon]
    if #SummonableCards > 0 then
	print("sms")
     for i=1,#SummonableCards do
      choice_l[#choice_l+1]={COMMAND_SUMMON,SummonableCards[i].cardid - MIN_CID }
     end
    end
    --[set ST]
    if #cards.st_setable_cards > 0 then
	print("sets")
     for i=1,#cards.st_setable_cards do
      choice_l[#choice_l+1]={COMMAND_SET_ST,cards.st_setable_cards[i].cardid - MIN_CID }
     end
    end
    --[reposition]
    if #RepositionableCards > 0 then
	print("repositions")
     for i=1,#RepositionableCards do
      choice_l[#choice_l+1]={COMMAND_CHANGE_POS,RepositionableCards[i].cardid - MIN_CID }
     end
    end
    --[set M]
    --[next phase]
    choice_l[#choice_l+1]={6,1}
    --[next turn]
    choice_l[#choice_l+1]={7,1}
	end 
	
	if #choice_l == 2 and Duel.GetCurrentPhase()==0x100 then
	 end_log()
	 return 7,1
	end

    --[add raw log, and select the 1st one]
    add_raw_log(choice_l, OHNKYTA_LOG_TABLE, {choice_l[1]}, OHNKYTA_LOG_SINGLE)
	print(choice_l[1][1],1)
    return choice_l[1][1],1
    --[]
  end
end

if combo then
 -----
 AI.Chat("Now it is : " .. ob1  .." - ".. ob2 )
 print("Now it is : " .. ob1  .." - ".. ob2 )
 get_next_step()
 AI.Chat("Now it comes to : " .. ob1 .." - "..  ob2 )
 print("Now it comes to : " .. ob1 .." - "..  ob2 )
 COMMAND_OHNKYTA_GLOBAL=nil
 gid=nil
 ida=nil
 idb=nil
 idc=nil
 seq=nil
 maxim=nil 
 selct=0 
 yesno=nil
 
 get_combo_info()

 --[minium cardid]
  find_min_cid()


 if (COMMAND_OHNKYTA_GLOBAL==nil and ida==0) or COMMAND_OHNKYTA_GLOBAL==7 then
 end_log()
 return 7,1
 end
 
 if COMMAND_OHNKYTA_GLOBAL==5 then 
  print("COMMAND_OHNKYTA_GLOBAL is activate")
  local b1,b2 = act(ActivatableCards,ida,seq) 
  if b1 and b2 then
  AI.Chat('act') 
  print('act')
  return b1,b2 
  end
 end
 
 -----
  if COMMAND_OHNKYTA_GLOBAL==COMMAND_SUMMON then 
  
   local b1,b2 =summon(SummonableCards,ida)
   if b1 and b2 then
    AI.Chat(' summon ') 
	print(' summon ') 
    return b1,b2
   end 
 end
 
 -----
  if COMMAND_OHNKYTA_GLOBAL==COMMAND_SPECIAL_SUMMON then 
  
   local b1,b2 =spsm(SpSummonableCards,ida)
   if b1 and b2 then
    AI.Chat(' spsm ') 
	print(' spsm ') 
    return b1,b2
   end 
 end
 
 -----
 if COMMAND_OHNKYTA_GLOBAL==COMMAND_SET_ST then 
  
  local b1,b2 =comd(COMMAND_SET_ST,cards.st_setable_cards,ida)
  if b1 and b2 then
    AI.Chat(' st_set ') 
	print(' st_set ') 
    return b1,b2
  end 
 end
 -----
end
  AI.Chat("DECISION: go to next phase")
  print("DECISION: go to next phase")
  --end_log()
  ------------------------------------------------------------
  -- Proceed to the next phase, and let AI write epic line in chat
  ------------------------------------------------------------
  -- there should be check here to see if the next phase is disallowed (like Karakuri having to attack)  I'm too lazy to make it right now, sorry. :*	
	return COMMAND_TO_NEXT_PHASE,1
end

