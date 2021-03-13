--受诅咒的水晶鞋
function c99988031.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99988031+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c99988031.target)
	e1:SetOperation(c99988031.activate)
	c:RegisterEffect(e1)
end
function c99988031.tgfilter(c)
	return c:IsSetCard(0x20df) and c:IsType(TYPE_MONSTER) and not c:IsRace(RACE_FIEND+RACE_ZOMBIE) and c:IsAbleToGrave()
end
function c99988031.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99988031.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c99988031.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99988031.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	    Duel.SendtoGrave(g,REASON_EFFECT)
	local g2=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_MONSTER)
	    if #g2>0 and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_MONSTER)==0
		 and Duel.SelectYesNo(tp,aux.Stringid(99988031,0)) then
     	     Duel.BreakEffect()
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			 local sg=g2:Select(tp,1,1,nil)
			 Duel.HintSelection(sg)
			 Duel.Destroy(sg,REASON_EFFECT)
		   end
	   end
	end   