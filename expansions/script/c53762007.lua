local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
end
function s.eqfilter(c,tp)
	return c:IsSetCard(0xc538) and c:IsType(TYPE_EQUIP) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and Duel.IsExistingMatchingCard(s.eqtgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c)
end
function s.eqtgfilter(c,eqc)
	return c:IsFaceup() and eqc:CheckEquipTarget(c)
end
function s.eqcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc538)
end
function s.ctfilter(c)
	return c:IsFaceup() and c:GetEquipGroup():IsExists(s.eqcfilter,1,nil) and c:IsControlerCanBeChanged()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local res1=c:IsAbleToGrave() and Duel.GetSZoneCount(tp,c)>0 and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_DECK,0,1,nil,tp)
	local res2=Duel.IsExistingMatchingCard(s.ctfilter,tp,0,LOCATION_MZONE,1,nil)
	if chk==0 then return res1 or res2 end
	local opt=0
	if res1 and not res2 then opt=Duel.SelectOption(tp,aux.Stringid(id,0)) end
	if not res1 and res2 then opt=Duel.SelectOption(tp,aux.Stringid(id,1))+1 end
	if res1 and res2 then opt=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1)) end
	e:SetLabel(opt)
	if opt==0 then
		if e:IsCostChecked() then e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_EQUIP) end
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,0,0)
	end
	if opt==1 then
		if e:IsCostChecked() then e:SetCategory(CATEGORY_CONTROL) end
		local g=Duel.GetMatchingGroup(s.ctfilter,tp,0,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local ec=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
			if ec then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
				local tc=Duel.SelectMatchingCard(tp,s.eqtgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,ec):GetFirst()
				Duel.Equip(tp,ec,tc)
			end
		end
	elseif e:GetLabel()==1 then
		local g=Duel.GetMatchingGroup(s.ctfilter,tp,0,LOCATION_MZONE,nil)
		Duel.GetControl(g,tp)
		local og=Duel.GetOperatedGroup()
		for tc in aux.Next(og) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CHANGE_LEVEL)
			e2:SetValue(2)
			tc:RegisterEffect(e2,true)
		end
	end
end
function s.tdfilter(c)
	return c:GetType()&0x40002==0x40002 or c:IsLevelBelow(2) and c:IsAbleToDeck()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.tdfilter(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.IsExistingTarget(s.tdfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	local c=e:GetHandler()
	if #g>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) and c:IsRelateToEffect(e) then Duel.SendtoHand(c,nil,REASON_EFFECT) end
end
