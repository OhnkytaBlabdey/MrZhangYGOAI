--zarc-ai
function c108211151.initial_effect(c)
	local e1 =Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c108211151.op)
	c:RegisterEffect(e1)
end


function c108211151.op(e,tp,eg,ep,ev,re,r,rp)
local g=Duel.GetFieldGroup(0,0xff,0xff)
Duel.SendtoDeck(g,nil,-1,0x400)
AddCard(0,8949584,LOCATION_HAND,0,POS_FACEDOWN)
--自己的卡组
dAddCard(40044918,0,0,LOCATION_DECK,0,POS_FACEUP_ATTACK) --元素英雄 天空侠
dAddCard(27780618,0,0,LOCATION_DECK,0,POS_FACEUP_ATTACK) --幻影英雄 仿生人
dAddCard(50720316,0,0,LOCATION_DECK,0,POS_FACEUP_ATTACK) --元素英雄 影雾女郎
dAddCard(9411399,0,0,LOCATION_DECK,0,POS_FACEUP_ATTACK) --命运英雄 魔性人
dAddCard(24094653,0,0,LOCATION_DECK,0,POS_FACEUP_ATTACK) --融合
dAddCard(11317977,0,0,LOCATION_DECK,0,POS_FACEUP_ATTACK) --月光黑羊
dAddCard(24094653,0,0,LOCATION_DECK,0,POS_FACEUP_ATTACK) --融合
dAddCard(83190280,0,0,LOCATION_DECK,0,POS_FACEUP_ATTACK) --月光虎
dAddCard(9411399,0,0,LOCATION_DECK,0,POS_FACEUP_ATTACK) --命运英雄 魔性人
dAddCard(38572779,0,0,LOCATION_DECK,0,POS_FACEUP_ATTACK) --幻创之混种恐龙
dAddCard(80727721,0,0,LOCATION_DECK,0,POS_FACEUP_ATTACK) --朱罗纪异特龙
dAddCard(58990362,0,0,LOCATION_DECK,0,POS_FACEUP_ATTACK) --秘龙星-神数囚牛
dAddCard(58990362,0,0,LOCATION_DECK,0,POS_FACEUP_ATTACK) --秘龙星-神数囚牛
dAddCard(9411399,0,0,LOCATION_DECK,0,POS_FACEUP_ATTACK) --命运英雄 魔性人
dAddCard(58990362,0,0,LOCATION_DECK,0,POS_FACEUP_ATTACK) --秘龙星-神数囚牛
dAddCard(32354768,0,0,LOCATION_DECK,0,POS_FACEUP_ATTACK) --神数的神托
dAddCard(20773176,0,0,LOCATION_DECK,0,POS_FACEUP_ATTACK) --炎兽之影灵衣-神数艾可萨
dAddCard(92746535,0,0,LOCATION_DECK,0,POS_FACEUP_ATTACK) --龙剑士 光辉星·灵摆
dAddCard(69610326,0,0,LOCATION_DECK,0,POS_FACEUP_ATTACK) --霸王眷龙 暗黑亚龙
--对方的卡组
--自己的额外
dAddCard(85115440,0,0,LOCATION_EXTRA,0,POS_FACEUP_ATTACK) --十二兽 牛犄
dAddCard(11510448,0,0,LOCATION_EXTRA,0,POS_FACEUP_ATTACK) --十二兽 虎炮
dAddCard(85115440,0,0,LOCATION_EXTRA,0,POS_FACEUP_ATTACK) --十二兽 牛犄
dAddCard(48905153,0,0,LOCATION_EXTRA,0,POS_FACEUP_ATTACK) --十二兽 龙枪
dAddCard(30757127,0,0,LOCATION_EXTRA,0,POS_FACEUP_ATTACK) --命运英雄 绝命人
dAddCard(27552504,0,0,LOCATION_EXTRA,0,POS_FACEUP_ATTACK) --永远的淑女 贝阿特丽切
dAddCard(55863245,0,0,LOCATION_EXTRA,0,POS_FACEUP_ATTACK) --龙子
dAddCard(65536818,0,0,LOCATION_EXTRA,0,POS_FACEUP_ATTACK) --源龙星-望天吼
dAddCard(1686814,0,0,LOCATION_EXTRA,0,POS_FACEUP_ATTACK) --奥特玛雅·卓尔金
dAddCard(18239909,0,0,LOCATION_EXTRA,0,POS_FACEUP_ATTACK) --爆龙剑士 点火星·日珥
dAddCard(22638495,0,0,LOCATION_EXTRA,0,POS_FACEUP_ATTACK) --刚龙剑士 雾动星·强力
dAddCard(91949988,0,0,LOCATION_EXTRA,0,POS_FACEUP_ATTACK) --迅雷之骑士 盖亚龙骑士
dAddCard(13331639,0,0,LOCATION_EXTRA,0,POS_FACEDOWN_ATTACK) --霸王龙 扎克

end

function dAddCard(code,pl,x,loc,seq,pos)
AddCard(pl,code,loc,seq,pos)
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