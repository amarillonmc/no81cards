--永夜抄·梦想天生
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:IsSetCard(0x3620) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsType(TYPE_EFFECT)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,2,nil) then
			local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
			local og=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
			if #g*#og==0 then return end
			local num=math.min(2,#og)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=g:Select(tp,0,num,nil)
			local oc=Duel.Destroy(sg,REASON_EFFECT)
			if oc==0 then return end
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg2=og:Select(tp,oc,oc,nil)
			Duel.Destroy(sg2,REASON_EFFECT)
		end
	end
end
function cm.desfilter(c)
	return c:IsType(TYPE_MONSTER)
end