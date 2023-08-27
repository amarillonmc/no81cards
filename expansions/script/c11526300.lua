--碳酸武装·百事
function c11526300.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,11526300)
	e1:SetCondition(c11526300.discon)
	e1:SetTarget(c11526300.distg)
	e1:SetOperation(c11526300.disop)
	c:RegisterEffect(e1)	
end
c11526300.SetCard_Carbonic_Acid_Girl=true 
--
function c11526300.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>=3
end
function c11526300.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c11526300.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local card=0
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.BreakEffect()
			local dg=Group.CreateGroup()
			for i=1,ev do
				local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
				if tgp==tp and (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and te:GetHandler().SetCard_Carbonic_Acid_Girl then
					local tc=te:GetHandler()
					card=card+1
				end
			end 
			if Duel.IsExistingMatchingCard(c11526300.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11526300,2)) then
				local gg=Duel.GetFieldGroup(c11526300.thfilter,tp,LOCATION_DECK,0,nil)
				if gg:GetCount()>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local g=Duel.SelectMatchingCard(tp,c11526300.thfilter,tp,LOCATION_DECK,0,1,card,nil)
					Duel.SendtoHand(g,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g)
				end  
			end
		end 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_DISEFFECT)
		e1:SetValue(c11526300.effectfilter)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,11526300,RESET_PHASE+PHASE_END,0,1)
	end
end
function c11526300.thfilter(c)
	return c.SetCard_Carbonic_Acid_Girl and c:IsAbleToHand()
end
function c11526300.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return tc.SetCard_Carbonic_Acid_Girl
end