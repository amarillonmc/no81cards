--偏移命运的韶光
function c9910464.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910464.target)
	e1:SetOperation(c9910464.activate)
	c:RegisterEffect(e1)
end
function c9910464.tgfilter1(c,e)
	return c:IsFaceup() and c:IsSetCard(0x9950) and c:IsAbleToGrave() and c:IsCanBeEffectTarget(e)
end
function c9910464.tgfilter2(c,e)
	return c:IsAbleToGrave() and c:IsCanBeEffectTarget(e)
end
function c9910464.filter1(g,e,tp,mc)
	local ct=g:GetCount()+1
	local mg=Group.FromCards(mc)
	mg:Merge(g)
	local g2=Duel.GetMatchingGroup(c9910464.tgfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,mg,e)
	return g2:CheckSubGroup(c9910464.filter2,ct,ct,tp,mg)
end
function c9910464.filter2(g,tp,mg)
	local ng=Group.CreateGroup()
	ng:Merge(g)
	ng:Merge(mg)
	return Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ng,0x1950,1)
end
function c9910464.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9910464.tgfilter1,tp,LOCATION_ONFIELD,0,c,e)
	if chkc then return false end
	if chk==0 then return #g>0 and g:CheckSubGroup(c9910464.filter1,1,g:GetCount(),e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910464,1))
	local g1=g:SelectSubGroup(tp,c9910464.filter1,false,1,g:GetCount(),e,tp,c)
	local ct=g1:GetCount()+1
	local mg=Group.FromCards(c)
	mg:Merge(g1)
	local g2=Duel.GetMatchingGroup(c9910464.tgfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,mg,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g3=g2:SelectSubGroup(tp,c9910464.filter2,false,ct,ct,tp,mg)
	g1:Merge(g3)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,g1:GetCount(),0,0)
end
function c9910464.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoGrave(g1,REASON_EFFECT)
	local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
	local g2=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e),0x1950,1)
	if ct>0 then
		for i=1,ct do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
			local sg2=g2:Select(tp,1,1,nil)
			sg2:GetFirst():AddCounter(0x1950,1)
		end
	end
	if Duel.GetCounter(tp,1,1,0x1950)<5 then return end
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c:CancelToGrave()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(9910464,0))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetRange(LOCATION_SZONE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetValue(aux.tgoval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetRange(LOCATION_SZONE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetValue(c9910464.val)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e3)
	end
end
function c9910464.val(e,c)
	return Duel.GetCounter(e:GetHandlerPlayer(),1,1,0x1950)*200
end
