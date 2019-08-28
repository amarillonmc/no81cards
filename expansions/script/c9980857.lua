--WIZARD
function c9980857.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0)
	e1:SetCost(c9980857.cost)
	e1:SetTarget(c9980857.target)
	e1:SetOperation(c9980857.operation)
	c:RegisterEffect(e1)
end
function c9980857.cfilter(c)
	return c:IsSetCard(0x5bc2) and c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c9980857.thfilter(c,code1,code2)
	return c:IsSetCard(0x5bc2) and c:IsAbleToHand() and not c:IsCode(9980857,code1,code2)
end
function c9980857.costcheck(g,tp)
	local code1=g:GetFirst():GetCode()
	local code2=g:GetNext():GetCode()
	local tg=Duel.GetMatchingGroup(c9980857.thfilter,tp,LOCATION_DECK,0,nil,code1,code2)
	return tg:CheckSubGroup(aux.dncheck,2,2)
end
function c9980857.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c9980857.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9980857.cfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return g:CheckSubGroup(c9980857.costcheck,2,2,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c9980857.costcheck,false,2,2,tp)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	sg:KeepAlive()
	e:SetLabelObject(sg)
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c9980857.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local code1=g:GetFirst():GetCode()
	local code2=g:GetNext():GetCode()
	local tg=Duel.GetMatchingGroup(c9980857.thfilter,tp,LOCATION_DECK,0,nil,code1,code2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=tg:SelectSubGroup(tp,aux.dncheck,false,2,2)
	if sg then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	   Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980857,0))
	end
end
