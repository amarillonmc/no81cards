--胧之渺翳 阿波希利魔
function c9911305.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,1,2)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c9911305.descon)
	e1:SetCost(c9911305.descost)
	e1:SetTarget(c9911305.destg)
	e1:SetOperation(c9911305.desop)
	c:RegisterEffect(e1)
	--inactivatable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9911305.efcon)
	e2:SetValue(c9911305.effilter)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e3)
end
function c9911305.filter(c,att)
	return c:GetOriginalAttribute()&att>0 and c:GetOriginalType()&TYPE_MONSTER>0 and (not c:IsOnField() or c:IsFaceup())
end
function c9911305.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct1=c:GetOverlayGroup():FilterCount(c9911305.filter,nil,ATTRIBUTE_EARTH)
	local ct2=c:GetEquipGroup():FilterCount(c9911305.filter,nil,ATTRIBUTE_EARTH)
	return ct1+ct2>0
end
function c9911305.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9911305.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa958)
end
function c9911305.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c9911305.desfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c9911305.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,2,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function c9911305.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c9911305.efcon(e)
	local c=e:GetHandler()
	local ct1=c:GetOverlayGroup():FilterCount(c9911305.filter,nil,ATTRIBUTE_WATER)
	local ct2=c:GetEquipGroup():FilterCount(c9911305.filter,nil,ATTRIBUTE_WATER)
	return ct1+ct2>0
end
function c9911305.effilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsRace(RACE_FIEND) and loc&LOCATION_MZONE>0
end
