--混调色泼洒
local s,id,o=GetID()
s.named_with_Combine_Color=1
function s.cc(c)
	if not c then return false end
	if _G["Combine_Color_Global_Codes"] and (_G["Combine_Color_Global_Codes"][c:GetCode()] or _G["Combine_Color_Global_Codes"][c:GetOriginalCode()]) then return true end
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Combine_Color
end
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end
function s.exfilter(c,e,tp)
	return s.cc(c) and c:IsType(TYPE_FUSION+TYPE_SYNCHRO) and (c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) or c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
		return #g>0--g:GetClassCount(Card.GetCode)>=3
	end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION+REASON_SYNCHRO)
	local og=Duel.GetOperatedGroup()
	local mat_g=og:Clone()
	local mg=mat_g:Filter(s.cc,nil)
	if not mg or mg:GetClassCount(Card.GetCode)<3 then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(id,3)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local exg=Duel.SelectMatchingCard(tp,s.exfilter,tp,0xff,0xff,1,1,nil,e,tp)
	if exg and #exg>0 then
		local fc=exg:GetFirst()
		fc:SetMaterial(mat_g)
		if fc:IsType(TYPE_FUSION) then
			--Duel.SendtoGrave(mat_g,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(fc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			fc:CompleteProcedure()
		elseif fc:IsType(TYPE_SYNCHRO) then
			--Duel.SendtoGrave(mat_g,REASON_EFFECT+REASON_MATERIAL+REASON_SYNCHRO)
			Duel.BreakEffect()
			Duel.SpecialSummon(fc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
			fc:CompleteProcedure()
		end
	end
end
function s.tdfilter(c)
	return s.cc(c) and c:IsAbleToDeck()
end
function s.hdfilter(c)
	return s.cc(c) and c:IsFaceup() and c:IsAbleToHand()
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_GRAVE,0,1,99,e:GetHandler())
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local hasFusion=Duel.GetOperatedGroup():IsExists(Card.IsType,1,nil,TYPE_FUSION)
	if hasFusion and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg=Duel.SelectMatchingCard(tp,s.hdfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
		if hg:GetCount()>0 then Duel.SendtoHand(hg,nil,REASON_EFFECT) end
	end
end