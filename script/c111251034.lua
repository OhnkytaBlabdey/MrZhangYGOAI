--cracker
function c111251034.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c111251034.op)
	c:RegisterEffect(e1)
	--skip turn
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TURN_END)
	e2:SetOperation(c111251034.skipop)
	e2:SetCondition(c111251034.con)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_DUEL)
	Duel.RegisterEffect(e2,1)
	--abate damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetValue(c111251034.damval)
	Duel.RegisterEffect(e3,1)
	--clear field
	local e4=Effect.GlobalEffect()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_TURN_END)
	e4:SetCondition(c111251034.con)
	e4:SetOperation(c111251034.preskip)
	e4:SetCountLimit(1)
	Duel.RegisterEffect(e4,1)
	--init field
	local e5=Effect.GlobalEffect()
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e5:SetOperation(c111251034.initop)
	Duel.RegisterEffect(e5,1)
end

function c111251034.op(e,tp,eg,ep,ev,re,r,rp)

local c=e:GetHandler()
Duel.SendtoDeck(c,tp,-2,0x400)
	--Clear
	local g0=Duel.GetFieldGroup(tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_REMOVED+LOCATION_FZONE,LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_REMOVED+LOCATION_FZONE)
	Duel.SendtoDeck(g0,nil,-2,0x400)
--AddCard(pl,code,loc,seq,pos)
c111251034.initop(e,tp,eg,ep,ev,re,r,rp)
end

function c111251034.con(e,tp,eg,ep,ev,re,r,rp)
return Duel.GetTurnPlayer()==tp

end
function c111251034.preskip(e,tp,eg,ep,ev,re,r,rp)
--Debug.ShowHint("preskip")
--Clear
local g0=Duel.GetFieldGroup(tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_REMOVED+LOCATION_FZONE,LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_REMOVED+LOCATION_FZONE)
Duel.SendtoDeck(g0,nil,-2,0x400)
end
function c111251034.skipop(e,tp,eg,ep,ev,re,r,rp)
--Debug.ShowHint("skipop")
--skip
local e0=Effect.CreateEffect(e:GetHandler())
e0:SetType(EFFECT_TYPE_FIELD)
e0:SetCode(EFFECT_SKIP_TURN)
e0:SetTargetRange(0,1)
e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
Duel.RegisterEffect(e0,tp)
end

function c111251034.damval(e,re,val,r,rp,rc)
if val >= Duel.GetLP(tp) then 
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

	return Duel.GetLP(tp)-1 
end
return val
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

function c111251034.initop(e,tp,eg,ep,ev,re,r,rp)
-- Duel.SetLP(0,Duel.GetTurnCount()) --[先攻者是0，开始时是第1回合]
--[AI 后手，首次AI的回合，清场]
if Duel.GetTurnCount()==2 then
c111251034.preskip(e,tp,eg,ep,ev,re,r,rp)
end
-- Debug.ShowHint("initop")
AddCard(tp,23571046,LOCATION_HAND,0,POS_FACEUP)
AddCard(tp,5318639,0x08,1,0xa)
AddCard(tp,5318639,LOCATION_HAND,1,POS_FACEUP)
end
