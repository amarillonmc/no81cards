function c4875172.initial_effect(c)   
   local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4875172,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c4875172.condition2)
	e2:SetTarget(c4875172.chtg)
	e2:SetOperation(c4875172.chop)
	c:RegisterEffect(e2)
end
function c4875172.condition2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp 
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and not (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c4875172.filter1(c)
	return c:IsFaceup()
end
function c4875172.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4875172.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
end
function c4875172.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c4875172.repop)
end
function c4875172.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c4875172.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end