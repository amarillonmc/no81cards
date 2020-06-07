--星辉之星仪
function c9910602.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--pub
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PUBLIC)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e2)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_SELF_TOGRAVE)
	e3:SetCondition(c9910602.sdcon)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,9910602)
	e4:SetCondition(c9910602.discon)
	e4:SetTarget(c9910602.distg)
	e4:SetOperation(c9910602.disop)
	c:RegisterEffect(e4)
end
function c9910602.sdcon(e)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_HAND,0)
	return #g==0 or g:GetClassCount(Card.GetCode)<#g
end
function c9910602.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_TRAP+TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c9910602.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c9910602.disop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		if g:GetClassCount(Card.GetCode)~=g:GetCount() and Duel.NegateActivation(ev) then
			local sg=Duel.GetMatchingGroup(Card.IsAbleToGrave,1-tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
			if sg:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(9910602,0)) then
				Duel.BreakEffect()
				local cg=sg:Select(1-tp,1,1,nil)
				if Duel.SendtoGrave(cg,REASON_EFFECT)~=0 then
					Duel.Draw(1-tp,1,REASON_EFFECT)
				end
			end
		end
		Duel.ShuffleHand(1-tp)
	end
end
