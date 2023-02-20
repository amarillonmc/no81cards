--连 结 之 心 ·奥 契 丝
local m=22348163
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,22348157)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348163,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetTarget(c22348163.sptg)
	e1:SetOperation(c22348163.spop)
	c:RegisterEffect(e1)
	--link summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348163,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,22348163)
	e2:SetCondition(c22348163.lscon)
	e2:SetTarget(c22348163.lstg)
	e2:SetOperation(c22348163.lsop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	
end
function c22348163.sprfilter(c)
	return true
end
function c22348163.sprfilter1(c)
	return c:IsCode(22348157) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function c22348163.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and 
	(
	(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c22348163.sprfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,nil) and Duel.IsExistingMatchingCard(c22348163.sprfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)) 
	or 
	(Duel.GetLocationCount(tp,LOCATION_MZONE)<1 and Duel.IsExistingMatchingCard(c22348163.sprfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c22348163.sprfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,nil) and Duel.IsExistingMatchingCard(c22348163.sprfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil))
	or
	(Duel.GetLocationCount(tp,LOCATION_MZONE)<1 and Duel.IsExistingMatchingCard(c22348163.sprfilter1,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c22348163.sprfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,nil)) 
	) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22348163.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	local g1=Duel.SelectMatchingCard(tp,c22348163.sprfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c22348163.sprfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,g1)
	local g=Group.__add(g1,g2)
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)==2 and (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE)) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	elseif Duel.IsExistingMatchingCard(c22348163.sprfilter1,tp,LOCATION_MZONE,0,1,nil) then
	local g1=Duel.SelectMatchingCard(tp,c22348163.sprfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
		if not g1:GetFirst():IsLocation(LOCATION_MZONE) then
		local g2=Duel.SelectMatchingCard(tp,c22348163.sprfilter,tp,LOCATION_MZONE,0,1,1,g1)
		local g=Group.__add(g1,g2)
		if #g>0 and Duel.Destroy(g,REASON_EFFECT)==2 and (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE)) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
		else
		local g2=Duel.SelectMatchingCard(tp,c22348163.sprfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,g1)
		local g=Group.__add(g1,g2)
		if #g>0 and Duel.Destroy(g,REASON_EFFECT)==2 and (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE)) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
		end


	elseif Duel.IsExistingMatchingCard(c22348163.sprfilter,tp,LOCATION_MZONE,0,1,nil) then
	local g1=Duel.SelectMatchingCard(tp,c22348163.sprfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c22348163.sprfilter,tp,LOCATION_MZONE,0,1,1,g1)
	local g=Group.__add(g1,g2)
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)==2 and (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE)) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	end
end
function c22348163.spfilter(c,tp)
	return c:IsFaceup() and c:IsCode(22348157) and c:IsControler(tp)
end
function c22348163.lscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348163.spfilter,1,nil,tp)
end
function c22348163.spfilter2(c,e,tp)
	return c:IsCode(22348157) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348163.lstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22348163.spfilter2,tp,LOCATION_GRAVE+LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_SZONE)
end
function c22348163.filter(c)
	return c:IsLinkSummonable(nil)
end
function c22348163.lsop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22348163.spfilter2),tp,LOCATION_GRAVE+LOCATION_SZONE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.SelectYesNo(tp,aux.Stringid(22348163,2)) and Duel.IsExistingMatchingCard(c22348163.filter,tp,LOCATION_EXTRA,0,1,nil) then
	local tg=Duel.SelectMatchingCard(tp,c22348163.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=tg:GetFirst()
	if tc then
		Duel.LinkSummon(tp,tc,nil)
	end
	end
end



