local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,s.matfilter,aux.NonTuner(nil),1,1)
	--excavate and summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--extra material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
	e2:SetCountLimit(1,id+o)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_MONSTER))
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function s.matfilter(c)
	return c:IsSummonType(SUMMON_TYPE_NORMAL)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.costfilter(c,tp)
	if not (c:IsLevelBelow(7) and c:IsAbleToDeckAsCost() 
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=c:GetLevel()) then return false end
	local g=Duel.GetDecktopGroup(tp,c:GetLevel())
	return g:FilterCount(Card.IsAbleToHand,nil)>0
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetLevel())
	Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_COST)
end
function s.thfilter(c)
	return c:IsSummonableCard() and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return end
	Duel.ConfirmDecktop(tp,ct)
	local g=Duel.GetDecktopGroup(tp,ct)
	if g:GetCount()>0 then
		local tg=g:Filter(s.thfilter,nil)
		if tg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=tg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			local tc=sg:GetFirst()
			if tc:IsSummonable(true,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				Duel.ShuffleDeck(tp)
				Duel.BreakEffect()
				Duel.Summon(tp,tc,true,nil)
			else Duel.ShuffleDeck(tp) end
		else Duel.ShuffleDeck(tp) end
	end
end