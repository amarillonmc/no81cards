--没有你的完美世界
local s,id,o=GetID()
s.MoJin=true
function s.initial_effect(c)
	aux.AddCodeList(c,5012604)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.filter1(c,e,tp)
	return c.MoJin and c:IsAbleToRemoveAsCost() and Duel.GetLocationCountFromEx(tp,tp,c)>0 and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,5,c) and c:IsFaceup()
end
function s.filter2(c)
	return c.MoJin and c:IsAbleToRemoveAsCost() and c:IsFaceup() and c:IsFaceup()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,1,1,c,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g1:Clone()
	sg:AddCard(c)
	local g2=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,5,5,sg,e,tp)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function s.filter(c,e,tp)
	return c:IsFacedown() and c.MoJin
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.matfilter2(c)
	return c:IsCanOverlay() and c:IsType(TYPE_QUICKPLAY) 
end
function s.cf(c)
	return Card.IsCanOverlay and not c:IsCode(5012625,5012613,5012617) --Card.IsCanOverlay
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		local tc=sg:GetFirst()
		local mg=Duel.GetMatchingGroup(s.cf,tp,LOCATION_DECK+LOCATION_REMOVED,0,nil)
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			--e1:SetDescription(1317)
			--e1:SetType(EFFECT_TYPE_SINGLE)
			--e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			--e1:SetCode(EFFECT_CANNOT_TRIGGER)
			--e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			--tc:RegisterEffect(e1)
		end
		Duel.SpecialSummonComplete()
		if tc:IsType(TYPE_XYZ) and #mg>0 and Duel.SelectYesNo(tp,aux.Stringid(5012606,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local mat=mg:Select(tp,1,3,nil)
			Duel.Overlay(tc,mat)
		end
	end
end
function s.tdfilter(c)
	return c:IsAbleToDeck() and c.MoJin
end
function s.thfilter(c)
	return c:IsAbleToHand() and c:IsFaceup() and c.MoJin
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.tdfilter),tp,LOCATION_GRAVE,0,e:GetHandler())
	if #sg==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=sg:Select(tp,1,#sg,nil)
	local tg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=tg:Select(tp,1,1,nil)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end