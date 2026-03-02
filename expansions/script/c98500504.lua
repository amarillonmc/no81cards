--试炼之地 英灵殿
function c98500504.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98500504+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c98500504.activate)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98500504,1))
	e2:SetCategory(CATEGORY_SUMMON+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c98500504.sumtg)
	e2:SetOperation(c98500504.sumop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98500504,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_NO_TURN_RESET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c98500504.spcost)
	e3:SetTarget(c98500504.sptg)
	e3:SetOperation(c98500504.spop)
	c:RegisterEffect(e3)
end
function c98500504.thfilter(c)
	return c:IsSetCard(0x42) and c:IsAbleToHand()
end
function c98500504.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c98500504.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(98500504,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c98500504.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_REMOVED,0,1,nil,0x42) and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x4b) end
	local ct=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x4b)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,ct,0,0)
end
function c98500504.tgop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x4b)
	local ct2=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_REMOVED,0,nil,0x42)
	if ct>0 and ct2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(98500504,3))
		local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_REMOVED,0,1,ct,nil,0x42)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
	end
end
function c98500504.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c98500504.filter1(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x4b) and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c98500504.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c98500504.filter2(c,e,tp,tcode)
	return c:IsSetCard(0x104f) and c.assault_name==tcode and c:IsCanBeSpecialSummoned(e,SUMMON_VALUE_ASSAULT_MODE,tp,false,true)
end
function c98500504.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c98500504.filter1,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,c98500504.filter1,1,1,nil,e,tp)
	Duel.SetTargetParam(rg:GetFirst():GetCode())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c98500504.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c98500504.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,code):GetFirst()
	if tc and Duel.SpecialSummon(tc,SUMMON_VALUE_ASSAULT_MODE,tp,tp,false,true,POS_FACEUP)>0 then
		tc:CompleteProcedure()
	   
	  
	end
end
function c98500504.sumfilter(c)
	return c:IsSetCard(0x42) and c:IsSummonable(true,nil)
end
function c98500504.sumfilter2(c,e,tp)
   return c:IsSetCard(0x42) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98500504.sumfilter3(c)
	return c:IsSetCard(0x4b) and c:IsFaceup()
end
function c98500504.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98500504.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) or (Duel.IsExistingMatchingCard(c98500504.sumfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c98500504.sumfilter3,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) end
	local b1=Duel.IsExistingMatchingCard(c98500504.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) 
	local b2=Duel.IsExistingMatchingCard(c98500504.sumfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c98500504.sumfilter3,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(98500504,4)},
		{b2,aux.Stringid(98500504,5)})
	e:SetLabel(op)
	if op==1 then
	   Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
	else
	   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
end
function c98500504.sumop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c98500504.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
	elseif op==2 then 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98500504.sumfilter2),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	end
end