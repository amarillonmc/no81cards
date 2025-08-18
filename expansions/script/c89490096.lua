--炯眼之供牺
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=aux.AddRitualProcGreater2Code(c,89490097,LOCATION_HAND,nil,nil,true,s.extraop)
	e1:SetCategory(e1:GetCategory()|CATEGORY_TOHAND+CATEGORY_SEARCH)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.rfilter(c)
	return c:IsSetCard(0xc30) and c:IsReason(REASON_RELEASE)
end
function s.extraop(e,tp,eg,ep,ev,re,r,rp,tc,mat)
	local g=mat:Filter(s.rfilter,nil)
	if #g>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>#g and Duel.GetDecktopGroup(tp,#g):IsExists(Card.IsAbleToHand,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.BreakEffect()
		Duel.ConfirmDecktop(tp,#g)
		local g=Duel.GetDecktopGroup(tp,#g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		Duel.RevealSelectDeckSequence(true)
		local sg=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil,tp)
		Duel.RevealSelectDeckSequence(false)
		if #sg>0 then
			Duel.DisableShuffleCheck(true)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end
	end
end
function s.filter(c)
	return c:IsFaceup() and c:IsAllTypes(TYPE_RITUAL+TYPE_SPELL) and not c:IsCode(id) and c:IsAbleToDeck()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,LOCATION_REMOVED)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_REMOVED,0,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
