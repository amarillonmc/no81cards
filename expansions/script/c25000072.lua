--蓝色夜晚的记忆
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rp==1-tp and (rc:GetType()==TYPE_SPELL or rc:IsType(TYPE_QUICKPLAY)) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,1)
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	if tc:GetType()==TYPE_SPELL or tc:IsType(TYPE_QUICKPLAY) then
		if c:IsRelateToEffect(e) and c:IsOnField() then
			c:CancelToGrave()
			Duel.SendtoHand(c,1-tp,REASON_EFFECT)
		end
	else
		local rc=re:GetHandler()
		if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) and rc:IsOnField() then
			rc:CancelToGrave()
			Duel.SendtoHand(rc,tp,REASON_EFFECT)
		end
	end
end
function s.handfilter(c)
	return c:GetType()==TYPE_SPELL or c:IsType(TYPE_QUICKPLAY)
end
function s.handcon(e)
	return Duel.GetMatchingGroupCount(s.handfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)==0
end