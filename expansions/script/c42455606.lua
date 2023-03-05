--混沌舞者
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,s.mfilter,nil,3,3)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_DRAW_PHASE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,4) or c:IsRank(4)
end
function s.spfilter(c,e,tp)
	return (c:IsSetCard(0xb6) or c:IsSetCard(0xb7) or c:IsSetCard(0xb8))
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.thfilter(c)
	return c:IsCode(26920296,49033797) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		if not c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then return false end
		local g=c:GetOverlayGroup()
		local g=g:Filter(Card.IsType,nil,TYPE_FUSION|TYPE_SYNCHRO|TYPE_XYZ)
		return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and g and #g>0
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.check(g)
	return g:FilterCount(Card.IsType,nil,TYPE_FUSION)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_SYNCHRO)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_XYZ)<=1
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then return end
	local g=c:GetOverlayGroup()
	local g=g:Filter(Card.IsType,nil,TYPE_FUSION|TYPE_SYNCHRO|TYPE_XYZ)
	if not g or #g<=0 then return end
	local ct=0
	if Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
		ct=1
		if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) then
			ct=3
		end
	end
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local sg=g:SelectSubGroup(tp,s.check,false,1,ct)
	if not sg then return end
	Duel.SendtoGrave(sg,REASON_EFFECT)
	Duel.RaiseSingleEvent(c,EVENT_DETACH_MATERIAL,e,0,0,0,0)
	if #sg>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		if #sg>1 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
			if #sg>2 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_ACTIVATE)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetTargetRange(0,1)
				e1:SetValue(s.actlimit)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function s.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
