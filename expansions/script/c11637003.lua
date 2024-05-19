--料理厨·烛火
local s,id,o=GetID()
function s.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.opetation)
	c:RegisterEffect(e1)
end

function s.IsFoodMaterial_Listed(c,code)
	if not c.FoodMaterial_Listed then return false end
	local flag=false
	for i=1,#c.FoodMaterial_Listed do
		if c.FoodMaterial_Listed[i]==code then flag=true end
	end
	return flag
end
function s.filter(c)
	if not c.FoodMaterial_Listed then return false end
	local codes={}
	for i=1,#c.FoodMaterial_Listed do
		table.insert(codes,c.FoodMaterial_Listed[i])
	end
	return (c:IsSetCard(0x9221) and #codes>0 and c:IsAbleToExtra() and c:IsFaceup()),codes
end
function s.spfilter(c,e,tp,tc,...)
	local codes={...}
	local flag=true
	for i=1,#codes do
		if not s.IsFoodMaterial_Listed(c,codes[i]) then flag=false end
	end
	return c:IsSetCard(0x9221) and flag and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,tc,c)
end
function s.filter2(c,e)
	return s.filter(c) and c:IsCanBeEffectTarget(e) 
end
function s.gselect(g,e,tp)
	local codes={}
	for tc in aux.Next(g) do
		for i=1,#tc.FoodMaterial_Listed do
			table.insert(codes,tc.FoodMaterial_Listed[i])
		end
	end
	return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g,table.unpack(codes))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then 
		local flag,codes=s.filter(chkc)
		return chkc:IsLocation(LOCATION_MZONE) and flag and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,chkc,table.unpack(codes))
	end
	local g=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then return g:CheckSubGroup(s.gselect,1,#g,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=g:SelectSubGroup(tp,s.gselect,false,1,#g,e,tp)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,#tg,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.opetation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		local codes={}
		for tmp in aux.Next(g) do
			for i=1,#tmp.FoodMaterial_Listed do
				table.insert(codes,tmp.FoodMaterial_Listed[i])
			end
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil,table.unpack(codes)):GetFirst()
		if not tc then return end
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and c:IsAbleToGrave() and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			Duel.SendtoGrave(c,nil,REASON_EFFECT)
		end
	end
end
