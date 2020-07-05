--莱茵生命·医疗干员-白面鸮
function c79029027.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c79029027.splimit)
	c:RegisterEffect(e2)
	--Recover
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c79029027.recost)
	e3:SetOperation(c79029027.reop)
	c:RegisterEffect(e3)
	--Recover 2
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,79029027)
	e4:SetTarget(c79029027.destg)
	e4:SetOperation(c79029027.desop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--atk def
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_PZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa900))
	e6:SetValue(c79029027.val)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e7)
end
function c79029027.val(e,c,Counter)  
	return Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x1099)*100
end
function c79029027.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xfa900) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c79029027.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1099,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1099,1,REASON_COST)
end
function c79029027.reop(e,tp,eg,ep,ev,re,r,rp)  
		Duel.Recover(tp,800,REASON_EFFECT)
end
function c79029027.filter(c)
	return c:IsSetCard(0xa900)
end
function c79029027.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	   if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c79029027.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79029027.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectTarget(tp,c79029027.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,g,1,0,0)
end
function c79029027.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.Recover(tp,tc:GetAttack()/2,REASON_EFFECT)
end
end
