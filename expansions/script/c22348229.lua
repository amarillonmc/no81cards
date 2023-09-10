--祭铜祀仪
function c22348229.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348229,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22348229+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22348229.destg)
	e1:SetOperation(c22348229.desop)
	c:RegisterEffect(e1) 
  
end
function c22348229.thfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x708) and c:IsAbleToHand()
end
function c22348229.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c22348229.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c22348229.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22348229.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)   
		if Duel.ConfirmCards(1-tp,g)~=0 and Duel.IsExistingMatchingCard(c22348229.smmfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22348229,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local tg=Duel.SelectMatchingCard(tp,c22348229.smmfilter,tp,LOCATION_HAND,0,1,1,nil)
			local ttc=tg:GetFirst()
			if ttc then
				local s1=ttc:IsSummonable(true,nil,1)
				local s2=ttc:IsMSetable(true,nil,1)
				if (s1 and s2 and Duel.SelectPosition(tp,ttc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
					Duel.Summon(tp,ttc,true,nil,1)
				else
					Duel.MSet(tp,ttc,true,nil,1)
				end
			end
		end
	end
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function c22348229.smmfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x708) and c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)
end
--

