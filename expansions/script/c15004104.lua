local m=15004104
local cm=_G["c"..m]
cm.name="岩钜的雷鸣虫 LV5"
function cm.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,15004104)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1,15004105)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
cm.lvup={15004106,15004107}
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if tc:IsPreviousLocation(LOCATION_ONFIELD) then
			if tc:IsPreviousControler(0) then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,15004104,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(0,15004104,RESET_PHASE+PHASE_END,0,1) end
end
function cm.desfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and cm.desfilter(chkc,tp) end
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(cm.desfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,15004104)~=0
end
function cm.sp1filter(c,e,tp)
	return c:IsCode(15004106) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function cm.sp2filter(c,e,tp)
	return c:IsCode(15004107) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and Duel.IsExistingMatchingCard(cm.bugfilter,tp,LOCATION_MZONE,0,1,aux.ExceptThisCard(e))
end
function cm.bugfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsFaceup()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and e:GetHandler():IsAbleToDeck() and (Duel.IsExistingMatchingCard(cm.sp1filter,tp,LOCATION_DECK,0,1,nil,e,tp) or Duel.IsExistingMatchingCard(cm.sp2filter,tp,LOCATION_DECK,0,1,nil,e,tp)) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not c:IsRelateToEffect(e) then return end
	if not c:IsAbleToDeck() then return end
	local b1=Duel.IsExistingMatchingCard(cm.sp1filter,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(cm.sp2filter,tp,LOCATION_DECK,0,1,nil,e,tp)
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,0))
	else op=Duel.SelectOption(tp,aux.Stringid(m,1))+1 end
	if op==0 then
		if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and c:IsLocation(LOCATION_DECK) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.sp1filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
			local tc=g:GetFirst()
			if tc then
				Duel.SpecialSummon(tc,SUMMON_VALUE_LV,tp,tp,true,true,POS_FACEUP)
				tc:CompleteProcedure()
			end
		end
	end
	if op==1 then
		if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and c:IsLocation(LOCATION_DECK) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.sp2filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
			local tc=g:GetFirst()
			if tc then
				Duel.SpecialSummon(tc,SUMMON_VALUE_LV,tp,tp,true,true,POS_FACEUP)
				tc:CompleteProcedure()
			end
		end
	end
end