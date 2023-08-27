--炭酸装姬·可口
function c11526301.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,11526301)
	e1:SetCondition(c11526301.discon)
	e1:SetTarget(c11526301.distg)
	e1:SetOperation(c11526301.disop)
	c:RegisterEffect(e1)	
end
c11526301.SetCard_Carbonic_Acid_Girl=true 
--
function c11526301.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>=2
end
function c11526301.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c11526301.disop(e,tp,eg,ep,ev,re,r,rp)
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
			if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11526301,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local gg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,card,nil)
				if gg:GetCount()>0 then
					Duel.HintSelection(gg)
					Duel.Destroy(gg,REASON_EFFECT)
				end
			end
		end 
	end
end
function c11526301.thfilter(c)
	return c.SetCard_Carbonic_Acid_Girl and c:IsAbleToHand()
end


