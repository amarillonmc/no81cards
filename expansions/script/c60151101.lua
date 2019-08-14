--├变节者 米拉┤
function c60151101.initial_effect(c)
	--coin
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60151101,2))
	e1:SetCategory(CATEGORY_COIN+CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,6011101)
	e1:SetCondition(c60151101.coincon)
	e1:SetTarget(c60151101.cointg)
	e1:SetOperation(c60151101.coinop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e111=Effect.CreateEffect(c)
	e111:SetDescription(aux.Stringid(60151101,2))
	e111:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e111:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e111:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e111:SetCode(EVENT_SUMMON_SUCCESS)
	e111:SetCountLimit(1,6011101)
	e111:SetCondition(c60151101.coincon2)
	e111:SetTarget(c60151101.cointg)
	e111:SetOperation(c60151101.coinop)
	c:RegisterEffect(e111)
	local e222=e111:Clone()
	e222:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e222)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60151101,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,60151101)
	e3:SetCondition(c60151101.spcon)
	e3:SetTarget(c60151101.sptg)
	e3:SetOperation(c60151101.spop)
	c:RegisterEffect(e3)
end
c60151101.toss_coin=true
function c60151101.coincon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsHasEffect(60151199)
end
function c60151101.coincon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsHasEffect(60151199)
end
function c60151101.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsHasEffect(60151199) then
		Duel.SetChainLimit(c60151101.chlimit)
		Duel.RegisterFlagEffect(tp,60151101,RESET_CHAIN,0,1)
	else
		Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function c60151101.chlimit(e,ep,tp)
	return tp==ep
end
function c60151101.filter(c)
	return c:IsSetCard(0x9b23) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c60151101.filter2(c)
	return c:IsAbleToGrave()
end
function c60151101.coinop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsFacedown() then return end
	local c=e:GetHandler()
	local res=0
	if Duel.GetFlagEffect(tp,60151101)>0 then
		res=1
	else res=Duel.TossCoin(tp,1) end
	if res==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,c60151101.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
		if g1:GetCount()>0 then
			Duel.SendtoGrave(g1,REASON_EFFECT)
		end
	end
	if res==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c60151101.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			if Duel.SendtoHand(g,nil,REASON_EFFECT) then
				Duel.ConfirmCards(1-tp,g)
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
function c60151101.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and re:GetHandler()~=e:GetHandler() and re:GetHandler():IsSetCard(0x9b23)
end
function c60151101.spfilter(c,e,tp)
	return c:IsSetCard(0x9b23) and not c:IsCode(60151101) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60151101.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c60151101.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c60151101.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c60151101.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
function c60151101.xyzlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x9b23)
end