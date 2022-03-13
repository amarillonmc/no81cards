local m=189103
local cm=_G["c"..m]
cm.name="灰烬机兵的决战"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.ovfilter(c)
	return c:IsSetCard(0xca6) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay() and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function cm.fselect(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)<3
end
function cm.filter(c,e,tp)
	local loc,ct=LOCATION_GRAVE,3
	if e:GetLabel()==1 then loc,ct=loc+LOCATION_REMOVED,99 end
	local g=Duel.GetMatchingGroup(cm.ovfilter,tp,loc,0,nil)
	return c:IsCode(189100) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and not c:IsCode(m) and g:CheckSubGroup(cm.fselect,1,ct)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,189101) then e:SetLabel(1) else e:SetLabel(0) end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,e:GetLabel()) end
	local loc=LOCATION_GRAVE
	if e:GetLabel()==1 then loc=loc+LOCATION_REMOVED end
	local g=Duel.GetMatchingGroup(cm.ovfilter,tp,loc,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,sg,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	local loc,ct=LOCATION_GRAVE,3
	if e:GetLabel()==1 then loc,ct=loc+LOCATION_REMOVED,99 end
	local g=Duel.GetMatchingGroup(cm.ovfilter,tp,loc,0,nil)
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg=g:SelectSubGroup(tp,cm.fselect,false,1,ct)
		if #sg>0 then Duel.Overlay(tc,sg) end
	end
end
