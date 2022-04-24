--教导的相剑圣骑兵
function c12057807.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WYRM+RACE_SPELLCASTER),aux.NonTuner(Card.IsRace,RACE_WYRM+RACE_SPELLCASTER),1)
	c:EnableReviveLimit()  
	--attribute
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_CANNOT_DISABLE)
	e0:SetCode(EFFECT_ADD_RACE)
	e0:SetValue(RACE_SPELLCASTER)
	e0:SetRange(0xff)
	c:RegisterEffect(e0)
	--double
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12057807,1))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DAMAGE+CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,12057807)
	e1:SetCondition(c12057807.condition)
	e1:SetTarget(c12057807.target)
	e1:SetOperation(c12057807.operation)
	c:RegisterEffect(e1) 
	--to deck 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12057807,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetCountLimit(1,22057807)
	e2:SetCondition(c12057807.rmcon)
	e2:SetTarget(c12057807.rmtg)
	e2:SetOperation(c12057807.rmop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--damage val
	local e5=e3:Clone()
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e5)	
end
function c12057807.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp 
end
function c12057807.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,1500)
end
function c12057807.operation(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)
	Duel.Damage(1-tp,1500,REASON_EFFECT) 
	end
end
function c12057807.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	e:SetLabelObject(bc)
	return c==Duel.GetAttacker() and bc and c:IsStatus(STATUS_OPPO_BATTLE) and bc:IsOnField() and bc:IsRelateToBattle()
end
function c12057807.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetLabelObject(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,1500)
end
function c12057807.rmop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() and bc:IsControler(1-tp) then
	Duel.SendtoDeck(bc,nil,2,REASON_EFFECT+REASON_RULE)
	Duel.Damage(1-tp,1500,REASON_EFFECT) 
	end
end





