--皇庭学院的乐姬
local m=21196015
local cm=_G["c"..m]
function cm.initial_effect(c)
	if not imperial_court then
		imperial_court=true
		Duel.LoadScript("c21196001.lua")
		in_count.card = c
		local ce1=Effect.CreateEffect(c)
		ce1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ce1:SetCode(EVENT_PHASE+PHASE_END)
		ce1:SetCountLimit(1)
		ce1:SetOperation(function(e)
			for tp = 0,1 do
				if not Duel.IsPlayerAffectedByEffect(tp,21196000) then
					in_count.reset(tp)
				end
			end
		end)
		Duel.RegisterEffect(ce1,0)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+1)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
function cm.q(c)
	return c:IsSetCard(0x5919) and c:IsType(TYPE_SPELL) and not c:IsPublic()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.q,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(3,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.q,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return in_count[tp] < 8 end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	in_count.add(tp,1)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,4)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,21196001,0,TYPES_TOKEN_MONSTER+TYPE_TUNER,500,500,10,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,4)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,21196001,0,TYPES_TOKEN_MONSTER+TYPE_TUNER,500,500,10,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,21196001)
	if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) and Duel.GetLocationCount(tp,4)>0 and in_count[tp] >= 2 and Duel.IsPlayerCanSpecialSummonMonster(tp,21196001,0,TYPES_TOKEN_MONSTER+TYPE_TUNER,500,500,10,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
	local token=Duel.CreateToken(tp,21196001)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end