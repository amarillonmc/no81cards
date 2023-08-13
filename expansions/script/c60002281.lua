--希望的断片·奇利烨
function c60002281.initial_effect(c)
	c:EnableCounterPermit(0x624)
	--to e1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c60002281.thtg)
	e1:SetOperation(c60002281.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--to e3
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60002281,1))
	e3:SetCategory(CATEGORY_COUNTER+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c60002281.spcost)
	e3:SetTarget(c60002281.sptg)
	e3:SetOperation(c60002281.spop)
	c:RegisterEffect(e3)
	--to e4
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetCondition(c60002281.incon)
	e4:SetValue(800)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE) 
	c:RegisterEffect(e5)


end
--exto e1
function c60002281.thfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c60002281.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c60002281.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c60002281.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c60002281.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=3 then
		local cg=Group.CreateGroup()
		for i=1,3 do
			local sg=g:RandomSelect(tp,1,1,nil)
			g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
			cg:Merge(sg)
		end
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		Duel.ConfirmCards(1-tp,cg)
		local tg=cg:Select(1-tp,1,1,nil)
		local tc=tg:GetFirst()
		if tc:IsAbleToHand() and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		   Duel.ConfirmCards(1-tp,tc)  
		   cg:RemoveCard(tc)
		end
		Duel.SendtoDeck(cg,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
--exto e3
function c60002281.cao(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(4) and c:IsType(TYPE_MONSTER)
end
function c60002281.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x624,2,REASON_COST) end
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,0x624,2,REASON_COST)
end
function c60002281.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c60002281.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c60002281.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c60002281.thfilter,tp,LOCATION_DECK,0,nil)
	if c:IsRelateToEffect(e) and c:AddCounter(0x624,1)~=0 then
		   if g:GetClassCount(Card.GetCode)>=3 then
		local cg=Group.CreateGroup()
		for i=1,3 do
			local sg=g:RandomSelect(tp,1,1,nil)
			g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
			cg:Merge(sg)
		end
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=cg:Select(1-tp,1,1,nil)
		local tc=tg:GetFirst()
		if tc:IsAbleToHand() and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		   Duel.ConfirmCards(1-tp,tc)  
		   cg:RemoveCard(tc)
		end
		 Duel.SendtoDeck(cg,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
	  end
	   if Duel.IsExistingMatchingCard(c60002281.cao,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(60002281,0)) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		 local g1=Duel.SelectMatchingCard(tp,c60002281.cao,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.RegisterFlagEffect(tp,60002148,RESET_PHASE+PHASE_END,0,1000)
	end
end

--exto e4
function c60002281.incon(e)
	return Card.GetCounter(e:GetHandler(),0x624)>=1
end