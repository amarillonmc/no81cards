--碧水凌涛
function c11182320.initial_effect(c)
	aux.AddCodeList(c,ATTRIBUTE_WATER)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11182320)
	e1:SetTarget(c11182320.tgtg)
	e1:SetOperation(c11182320.tgop)
	c:RegisterEffect(e1)
	--special
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,11182320+1)
	e2:SetCondition(c11182320.dspcon)
	e2:SetTarget(c11182320.dsptg)
	e2:SetOperation(c11182320.dspop)
	c:RegisterEffect(e2)
	local e22=e2:Clone()
	e22:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e22)
end
function c11182320.dspcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc
	if c:IsReason(REASON_BATTLE) then tc=c:GetBattleTarget() end
	if c:IsReason(REASON_EFFECT+REASON_COST) then tc=re:GetHandler() end
	return tc and tc:IsSetCard(0x6454)
end
function c11182320.dspfilter(c,e,tp)
	return c:IsSetCard(0x6454) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11182320.dsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11182320.dspfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c11182320.dspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11182320.dspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c11182320.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c11182320.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g<1 then return end
	Duel.HintSelection(g)
	if Duel.SendtoGrave(g,REASON_EFFECT)>0 and g:GetFirst():IsLocation(0x10) then
		local ch=Duel.GetCurrentChain()
		if ch>1 then
			local code=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_CODE)
			local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
			if code==11182320 and #g>0
				and Duel.SelectYesNo(tp,aux.Stringid(11182320,0)) then
				Duel.ConfirmCards(tp,g)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local tg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil)
				if tg:GetCount()>0 then
					Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
				end
				Duel.ShuffleExtra(1-tp)
			end
		end
	end
end