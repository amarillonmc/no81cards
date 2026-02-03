--远古造物 金伯拉虫
Duel.LoadScript("c9910700.lua")
function c9910702.initial_effect(c)
	--flag
	QutryYgzw.AddTgFlag(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9910702)
	e1:SetCost(c9910702.thcost)
	e1:SetTarget(c9910702.thtg)
	e1:SetOperation(c9910702.thop)
	c:RegisterEffect(e1)
end
function c9910702.cfilter(c)
	return c:IsSetCard(0xc950) and c:IsAbleToGraveAsCost()
end
function c9910702.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910702.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910702.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	local cg=g:Filter(Card.IsFacedown,nil)
	Duel.ConfirmCards(1-tp,cg)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9910702.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFieldCard(tp,LOCATION_GRAVE,0)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) or (tc and tc:IsAbleToHand()) end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9910702.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	if Duel.Recover(tp,500,REASON_EFFECT)>0 then
		local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
		local tc1=nil
		if #g>0 then tc1=g:GetMinGroup(Card.GetSequence):GetFirst() end
		local tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,0)
		local b=tc2 and aux.NecroValleyFilter()(tc2)
		if not tc1 and not b then return end
		if tc1 and (not b or Duel.SelectOption(tp,aux.Stringid(9910702,0),aux.Stringid(9910702,1))==0) then
			Duel.BreakEffect()
			Duel.DisableShuffleCheck()
			tc1:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
			Duel.SendtoHand(tc1,tp,REASON_EFFECT)
		else
			Duel.BreakEffect()
			if Duel.SendtoHand(tc2,tp,REASON_EFFECT)>0 then Duel.ConfirmCards(1-tp,tc2) end
		end
		Duel.ShuffleHand(tp)
	end
end
