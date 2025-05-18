--艾奇军团 谋略者
function c60151105.initial_effect(c)
	--coin
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60151101,2))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,6011105)
	e1:SetTarget(c60151105.cointg)
	e1:SetOperation(c60151105.coinop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60151105,3))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,60151105)
	e3:SetCondition(c60151105.spcon)
	e3:SetTarget(c60151105.sptg)
	e3:SetOperation(c60151105.spop)
	c:RegisterEffect(e3)
end
c60151105.toss_coin=true
function c60151105.coincon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsHasEffect(60151199)
end
function c60151105.coincon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsHasEffect(60151199)
end
function c60151105.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60151105.filter,tp,LOCATION_DECK,0,1,nil) end
	if e:GetHandler():IsHasEffect(60151199) then
		Duel.SetChainLimit(c60151105.chlimit)
		Duel.RegisterFlagEffect(tp,60151105,RESET_CHAIN,0,1)
	else
		e:SetCategory(CATEGORY_COIN+CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c60151105.chlimit(e,ep,tp)
	return tp==ep
end
function c60151105.filter(c)
	return c:IsSetCard(0x9b23) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c60151105.filter2(c)
	return c:IsAbleToGrave()
end
function c60151105.coinop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsFacedown() then return end
	local c=e:GetHandler()
	if c:IsFacedown() then return end
	local res=0
	if Duel.GetFlagEffect(tp,60151105)>0 then
		res=1
	else res=Duel.TossCoin(tp,1) end
	if res==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,c60151105.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
		if g1:GetCount()>0 then
			Duel.SendtoGrave(g1,REASON_EFFECT)
		end
	end
	if res==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c60151105.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then 
				local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
				if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60151101,0)) then
					Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local sg=g2:Select(tp,1,1,nil)
					Duel.SendtoGrave(sg,REASON_EFFECT)
				end
			end
		end
	end
end
function c60151105.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and re:GetHandler()~=e:GetHandler()
end
function c60151105.spfilter(c)
	return c:IsSetCard(0x9b23) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c60151105.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c60151105.spfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60151105.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60151105.spfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT) then
			Duel.ConfirmCards(1-tp,g)
			local g8=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
			if g8:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60151101,0)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local sg=g8:Select(tp,1,1,nil)
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
		end
	end
end