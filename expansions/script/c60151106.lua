--├红枫指挥官 文┤
function c60151106.initial_effect(c)
	--sp
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_SPSUMMON_PROC)
	e12:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e12:SetRange(LOCATION_HAND)
	e12:SetCondition(c60151106.spcon2)
	e12:SetOperation(c60151106.spop2)
	c:RegisterEffect(e12)
	--coin
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60151101,2))
	e1:SetCategory(CATEGORY_COIN+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,6011106)
	e1:SetCondition(c60151106.coincon)
	e1:SetTarget(c60151106.cointg)
	e1:SetOperation(c60151106.coinop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e111=Effect.CreateEffect(c)
	e111:SetDescription(aux.Stringid(60151101,2))
	e111:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e111:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e111:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e111:SetCode(EVENT_SUMMON_SUCCESS)
	e111:SetCountLimit(1,6011106)
	e111:SetCondition(c60151106.coincon2)
	e111:SetTarget(c60151106.cointg)
	e111:SetOperation(c60151106.coinop)
	c:RegisterEffect(e111)
	local e222=e111:Clone()
	e222:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e222)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60151106,1))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,60151106)
	e3:SetCondition(c60151106.spcon)
	e3:SetTarget(c60151106.sptg)
	e3:SetOperation(c60151106.spop)
	c:RegisterEffect(e3)
end
c60151106.toss_coin=true
function c60151106.coincon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsHasEffect(60151199)
end
function c60151106.coincon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsHasEffect(60151199)
end
function c60151106.spfilter2(c)
	return c:IsSetCard(0x9b23) and c:IsType(TYPE_MONSTER) and not c:IsCode(60151106) and c:IsAbleToGrave()
end
function c60151106.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 then 
		return Duel.IsExistingMatchingCard(c60151106.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
			and Duel.IsExistingMatchingCard(c60151106.spfilter2,tp,LOCATION_ONFIELD,0,1,nil)
	else
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and Duel.IsExistingMatchingCard(c60151106.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,nil)
	end
end
function c60151106.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,c60151106.spfilter2,tp,LOCATION_ONFIELD,0,1,1,nil)
		local tc=g1:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectMatchingCard(tp,c60151106.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,tc)
		local g=Group.CreateGroup()
		g:Merge(g1)
		g:Merge(g2)
		local tc2=g:GetFirst()
		while tc2 do
			if not tc2:IsFaceup() then Duel.ConfirmCards(1-tp,tc2) end
			tc2=g:GetNext()
		end
		Duel.SendtoGrave(g,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,c60151106.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,2,nil)
		local tc=g1:GetFirst()
		while tc do
			if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
			tc=g1:GetNext()
		end
		Duel.SendtoGrave(g1,REASON_EFFECT)
	end
end
function c60151106.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsHasEffect(60151199) then
		Duel.SetChainLimit(c60151106.chlimit)
		Duel.RegisterFlagEffect(tp,60151106,RESET_CHAIN,0,1)
	else
		Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c60151106.chlimit(e,ep,tp)
	return tp==ep
end
function c60151106.spfilter(c,e,tp)
	return c:IsSetCard(0x9b23) and c:GetLevel()==4 and not c:IsCode(60151106) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60151106.filter2(c)
	return c:IsAbleToGrave()
end
function c60151106.coinop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsFacedown() then return end
	local c=e:GetHandler()
	if c:IsFacedown() then return end
	local res=0
	if Duel.GetFlagEffect(tp,60151106)>0 then
		res=1
	else res=Duel.TossCoin(tp,1) end
	if res==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,c60151106.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
		if g1:GetCount()>0 then
			Duel.SendtoGrave(g1,REASON_EFFECT)
		end
	end
	if res==1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c60151106.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
			local tc=g:GetFirst()
			while tc do
				if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
					
					Duel.SpecialSummonComplete()
				end
				tc=g:GetNext()
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c60151106.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,2,nil,e,tp)
			local tc=g:GetFirst()
			while tc do
				if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
					
					Duel.SpecialSummonComplete()
				end
				tc=g:GetNext()
			end
		end
	end
end
function c60151106.xyzlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x9b23)
end
function c60151106.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and re:GetHandler()~=e:GetHandler()
		and re:GetHandler():IsSetCard(0x9b23)
end
function c60151106.filter(c)
	return c:IsSetCard(0x9b23) and c:IsAbleToDeck()
end
function c60151106.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c60151106.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function c60151106.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c60151106.filter,tp,LOCATION_GRAVE,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		if Duel.Draw(tp,1,REASON_EFFECT)~=0 then 
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