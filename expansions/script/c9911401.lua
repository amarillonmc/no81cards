--苍穹之兽王骑士
function c9911401.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c9911401.mfilter,aux.TRUE,2,2)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9911401)
	e1:SetCost(c9911401.thcost)
	e1:SetTarget(c9911401.thtg)
	e1:SetOperation(c9911401.thop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9911402)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCondition(c9911401.spcon)
	e2:SetCost(c9911401.spcost)
	e2:SetTarget(c9911401.sptg)
	e2:SetOperation(c9911401.spop)
	c:RegisterEffect(e2)
end
function c9911401.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,4) or c:IsXyzLevel(xyzc,8)
end
function c9911401.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9911401.thfilter(c)
	return c:IsLevelAbove(5) and c:IsRace(RACE_BEASTWARRIOR) and c:IsAbleToHand()
end
function c9911401.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911401.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9911401.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9911401.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9911401.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c9911401.gcheck1(g,tp)
	return g:IsExists(c9911401.typfilter,1,nil,tp)
end
function c9911401.typfilter(c,tp)
	local type1=c:GetType()&0x7
	return Duel.IsExistingMatchingCard(c9911401.xmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,type1)
end
function c9911401.xmfilter(c,type1)
	return c:IsType(type1) and c:IsFaceup() and c:IsCanOverlay()
end
function c9911401.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	if chk==0 then return g:CheckSubGroup(c9911401.gcheck1,2,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local sg=g:SelectSubGroup(tp,c9911401.gcheck1,false,2,2,tp)
	Duel.SendtoGrave(sg,REASON_DISCARD+REASON_COST)
	local type1=sg:GetFirst():GetType()&0x7
	type1=sg:GetNext():GetType()&0x7|type1
	e:SetLabel(type1)
end
function c9911401.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsType(TYPE_XYZ)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9911401.gcheck2(g,type1,type2)
	return #g==1 or aux.gfcheck(g,Card.IsType,type1,type2)
end
function c9911401.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local type1=e:GetLabel()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and type1>0 then
		local g=Duel.GetMatchingGroup(c9911401.xmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,type1)
		if #g==0 then return end
		local type2=0
		if type1&0x1~=0 then
			type2=type1-0x1
			type1=0x1
		elseif type1&0x2~=0 then
			type2=type1-0x2
			type1=0x2
		end
		local sg=Group.CreateGroup()
		if type2==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			sg=g:Select(tp,1,1,nil)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			sg=g:SelectSubGroup(tp,c9911401.gcheck2,false,1,2,type1,type2)
		end
		if #sg==0 then return end
		Duel.HintSelection(sg)
		local og=Group.CreateGroup()
		for tc in aux.Next(sg) do
			og:Merge(tc:GetOverlayGroup())
			tc:CancelToGrave()
		end
		if #og>0 then Duel.SendtoGrave(og,REASON_RULE) end
		Duel.Overlay(c,sg)
	end
end
