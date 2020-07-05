--莱茵生命·辅助干员-梅尔
function c79029074.initial_effect(c)
	 --pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c79029074.splimit)
	c:RegisterEffect(e2)
	--token  
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,79029074)
	e3:SetTarget(c79029074.thtg)
	e3:SetOperation(c79029074.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4) 
	--Draw and atk
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c79029074.recost)
	e5:SetTarget(c79029074.retg)
	e5:SetOperation(c79029074.reop)
	c:RegisterEffect(e5)
	--p effect
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetRange(LOCATION_PZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(c79029074.atktg)
	e6:SetValue(1000)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e7)
	--token 2
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_PZONE)
	e8:SetCountLimit(1)
	e8:SetTarget(c79029074.thtg)
	e8:SetOperation(c79029074.thop)
	c:RegisterEffect(e8)
	--atk 
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_UPDATE_ATTACK)
	e9:SetValue(c79029074.atkval)
	c:RegisterEffect(e9)
end
function c79029074.atktg(e,c)
	return c:IsType(TYPE_TOKEN)
end
function c79029074.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa900) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c79029074.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,79029075,0,0x4011,500,800,1,RACE_CYBERSE,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c79029074.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,79029075,0,0x4011,500,800,1,RACE_CYBERSE,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,79029075)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c79029074.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x1099,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1099,1,REASON_COST)
end
function c79029074.filter3(c)
	return c:IsCode(79029075)
end
function c79029074.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c79029074.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c79029074.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c79029074.reop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c79029074.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.Destroy(sg,REASON_EFFECT)
	local x=sg:GetCount()
	Duel.Draw(tp,x,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(x*1000)
		e1:SetReset(RESET_EVENT+RESET_EVENT+RESETS_STANDARD)
		e:GetHandler():RegisterEffect(e1)
end
function c79029074.atkfilter(c)
	return c:IsFaceup() and c:IsCode(79029075)
end
function c79029074.atkval(e,c)
	return Duel.GetMatchingGroupCount(c79029074.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)*1000
end