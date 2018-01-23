--load puzzle
function c101221614.initial_effect(c)
	local e1 =Effect.GlobalEffect()
	
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_TURN_END)
	e1:SetCondition(function() return true end)
	-- e1:SetTarget()
	e1:SetRange(0,1)
	e1:SetOperation(c101221614.op)
	Duel.RegisterEffect(e1,1)
	
	-- player 1 is ready to crack and player 0 is the defender. 
	--init skip phase
	local e5=Effect.GlobalEffect()
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e5:SetOperation(c101221614.skip)
	Duel.RegisterEffect(e5,1)
end

function c101221614.skip(e,tp,eg,ep,ev,re,r,rp)
if Duel.GetTurnCount()==1 then
tp=0
--
local e1=Effect.GlobalEffect()
e1:SetType(EFFECT_TYPE_FIELD)
e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
e1:SetTargetRange(1,0)
e1:SetCode(EFFECT_SKIP_DP)
e1:SetReset(RESET_PHASE+PHASE_END)
Duel.RegisterEffect(e1,tp)
--
local e2=Effect.GlobalEffect()
e2:SetType(EFFECT_TYPE_FIELD)
e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
e2:SetTargetRange(1,0)
e2:SetCode(EFFECT_SKIP_SP)
e2:SetReset(RESET_PHASE+PHASE_END)
Duel.RegisterEffect(e2,tp)
--
local e3=Effect.GlobalEffect()
e3:SetType(EFFECT_TYPE_FIELD)
e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
e3:SetTargetRange(1,0)
e3:SetCode(EFFECT_SKIP_M1)
e3:SetReset(RESET_PHASE+PHASE_END)
Duel.RegisterEffect(e3,tp)
--
local e4=Effect.GlobalEffect()
e4:SetType(EFFECT_TYPE_FIELD)
e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
e4:SetTargetRange(1,0)
e4:SetCode(EFFECT_SKIP_BP)
e4:SetReset(RESET_PHASE+PHASE_END)
Duel.RegisterEffect(e4,tp)
--
local e6=Effect.GlobalEffect()
e6:SetType(EFFECT_TYPE_FIELD)
e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
e6:SetTargetRange(1,0)
e6:SetCode(EFFECT_CANNOT_BP)
e6:SetReset(RESET_PHASE+PHASE_END)
Duel.RegisterEffect(e6,tp)
--
local e5=Effect.GlobalEffect()
e5:SetType(EFFECT_TYPE_FIELD)
e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
e5:SetTargetRange(1,0)
e5:SetCode(EFFECT_SKIP_M2)
e5:SetReset(RESET_PHASE+PHASE_END)
Duel.RegisterEffect(e5,tp)
end
end

function c101221614.op(e,tp,eg,ep,ev,re,r,rp)
 --[先攻者是0，开始时是第1回合]
--[AI 后手，首次AI的回合，清场]

if Duel.GetTurnCount()==1 then

if not io then
io=require("io")
end
if not os then
os=require("os")
end
	--[read xx.lua as puzzle file]
	local pz_file = io.open("single/xx.lua","r+")
	if not pz_file then 
	return 
	end

	local line_str=pz_file:read()
	local ct=0
	while(line_str) do
		_,ct = line_str:gsub("Debug.AddCard","_")
		if(ct==1)then
		local para_table=line_str:split(",")

		-- Debug.AddCard(102380,1,1,16,0,1)
		-- AddCard(pl,code,loc,seq,pos)
		showtable(para_table)

		tmp=para_table[1]

		local cd=''..tmp:sub(15,-1)
		code=tonumber(cd)
		-- cd="code"
		pl=tonumber(para_table[2])
		loc=tonumber(para_table[4])
		seq=tonumber(para_table[5])
		tmp=para_table[6]
		local tmpstrpos=tmp:sub(1,-2)
		pos=tonumber(tmpstrpos)

		AddCard(pl,code,loc,seq,pos)
		end
		line_str=pz_file:read()
	end
	pz_file:close()
elseif Duel.GetTurnCount()==2 then
Duel.SetLP(1,0)
-- [turn limit]
end

end

function showtable(t)
if not t then 
Debug.ShowHint("this is nil value")
Duel.BreakEffect()
return 0
end

local ct = #t
if ct and ct>0 then
else
Debug.ShowHint(" table of nil")
Duel.BreakEffect()
return 0
end

local i=0
local str=""
for i=1,ct do
	if t[i] then
	str=str..i.."\t:"..t[i]..',,\t'
	end
end
	Debug.ShowHint(str)
	Duel.BreakEffect()
end

--
function AddCard(pl,code,loc,seq,pos)
if seq then
else
seq=0
end
local c_a=Duel.CreateToken(pl,code)
if loc==LOCATION_GRAVE then
Duel.SendtoGrave(c_a,REASON_RULE)
elseif loc==LOCATION_HAND then
Duel.SendtoHand(c_a,pl,REASON_RULE)
elseif loc==LOCATION_EXTRA then
Duel.SendtoDeck(c_a,pl,seq,REASON_RULE)
elseif loc==LOCATION_DECK then
Duel.SendtoDeck(c_a,pl,seq,REASON_RULE)
elseif loc==LOCATION_REMOVED then
Duel.Remove(c_a,POS_FACEUP,0x400)
elseif loc==LOCATION_MZONE or loc==LOCATION_SZONE or loc==LOCATION_FZONE then
Duel.SendtoDeck(c_a,pl,0,REASON_RULE)
Duel.MoveToField(c_a,pl,pl,loc,pos,false)
end
--
Duel.MoveSequence(c_a,seq)
return c_a
end

--字符串分割函数
--传入字符串和分隔符，返回分割后的table
function string.split(str, delimiter)
	if str==nil or str=='' or delimiter==nil then
		return nil
	end
	
    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end