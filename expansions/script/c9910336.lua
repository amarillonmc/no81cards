--神树勇者的开海
function c9910336.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c9910336.condition)
	e1:SetTarget(c9910336.target)
	e1:SetOperation(c9910336.activate)
	c:RegisterEffect(e1)
end
function c9910336.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x956)
end
function c9910336.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9910336.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9910336.thfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c9910336.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9910336.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local g=Duel.GetMatchingGroup(c9910336.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c9910336.locfilter(c,sp)
	return c:IsLocation(LOCATION_HAND) and c:IsControler(sp)
end
function c9910336.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910336.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	local ct1=Duel.GetOperatedGroup():FilterCount(c9910336.locfilter,nil,tp)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if ct1>ct2 then ct1=ct2 end
	if ct1>0 and Duel.SelectYesNo(tp,aux.Stringid(9910336,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,ct1,aux.ExceptThisCard(e))
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
