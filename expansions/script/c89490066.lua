--炯眼龙骑士
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,89490015)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atlimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(aux.NOT(s.qcon))
	e5:SetCost(s.rcost)
	e5:SetTarget(s.rtg)
	e5:SetOperation(s.rop)
	c:RegisterEffect(e5)
	local e55=e5:Clone()
	e55:SetType(EFFECT_TYPE_QUICK_O)
	e55:SetCode(EVENT_FREE_CHAIN)
	e55:SetCondition(s.qcon)
	c:RegisterEffect(e55)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
function s.atlimit(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsLevelBelow(8) and not c:IsImmuneToEffect(e)
end
function s.efilter(e,te)
	local tc=te:GetOwner()
	return tc:IsType(TYPE_MONSTER) and tc:IsLevelBelow(8)
end
function s.qcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsPlayerAffectedByEffect(tp,89490011)~=nil and c:IsOriginalSetCard(0xc30) and c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_MONSTER)
end
function s.costfilter(c)
	return c:IsRace(RACE_WYRM) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.tgfilter(c)
	return c:IsRace(RACE_WYRM) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function s.rlfilter(c)
	return c:IsFaceup() and c:IsReleasable()
end
function s.rcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fe1=Duel.IsPlayerAffectedByEffect(tp,89490052)
	local b1=fe1 and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil)
	local fe2=Duel.IsPlayerAffectedByEffect(tp,89490080)
	local b2=fe2 and Duel.IsExistingMatchingCard(s.rlfilter,tp,0,LOCATION_MZONE,1,nil)
	local b3=Duel.CheckReleaseGroup(tp,s.costfilter,1,e:GetHandler())
	if chk==0 then return b1 or b2 or b3 end
	local op=aux.SelectFromOptions(tp,{b1,fe1 and fe1:GetDescription() or nil},{b2,fe2 and fe2:GetDescription() or nil},{b3,1150})
	if op==1 then
		Duel.Hint(HINT_CARD,0,89490052)
		fe1:UseCountLimit(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	elseif op==2 then
		Duel.Hint(HINT_CARD,0,89490080)
		fe2:UseCountLimit(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,s.rlfilter,tp,0,LOCATION_MZONE,1,1,nil)
		local tc=g:GetFirst()
		Duel.Release(tc,REASON_COST)
		if tc:IsSetCard(0xc30) then
			e:SetProperty(e:GetProperty()|EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
		else
			e:SetProperty(e:GetProperty()&~(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN))
		end
	else
		local g=Duel.SelectReleaseGroup(tp,s.costfilter,1,1,e:GetHandler())
		local tc=g:GetFirst()
		Duel.Release(tc,REASON_COST)
		if tc:IsSetCard(0xc30) then
			e:SetProperty(e:GetProperty()|EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
		else
			e:SetProperty(e:GetProperty()&~(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN))
		end
	end
end
function s.rmfilter(c)
	return c:IsSetCard(0xc30) and c:IsAllTypes(TYPE_RITUAL+TYPE_SPELL)
end
function s.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(s.rmfilter,tp,LOCATION_GRAVE,0,nil)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function s.rop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(s.rmfilter,tp,LOCATION_GRAVE,0,nil)
	if ct<=0 then return end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,ct,nil)
		Duel.HintSelection(sg)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function s.thfilter(c)
	return c:IsSetCard(0xc30) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
