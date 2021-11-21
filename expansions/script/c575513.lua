--PSY骨架瞬移
function c575513.initial_effect(c)
	c:SetUniqueOnField(1,0,575513)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--adjust
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetRange(LOCATION_DECK)
	e2:SetOperation(c575513.effop)
	c:RegisterEffect(e2)
	--activate(destroy)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(575513,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(3,575513)
	e3:SetCondition(c575513.condition)
	e3:SetTarget(c575513.target)
	e3:SetOperation(c575513.activate)
	c:RegisterEffect(e3)
end
function c575513.efffilter(c,lg,ignore_flag)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0xc1)
		and (ignore_flag or c:GetFlagEffect(575513)==0)
end
function c575513.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c575513.efffilter,tp,LOCATION_HAND,0,nil)
	if c:IsDisabled() then return end
	for tc in aux.Next(g) do
		if tc:GetFlagEffect(575513)==0 then
			tc:RegisterFlagEffect(575513,RESET_EVENT+0x1fe0000,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAINING)
			e1:SetRange(LOCATION_HAND)
			e1:SetLabelObject(c)
			e1:SetCondition(c575513.discon)
			e1:SetTarget(c575513.fieldtg)
			e1:SetOperation(c575513.fieldop)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
		end
	end
end
function c575513.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gc=e:GetLabelObject()
	return gc and gc:IsLocation(LOCATION_DECK)
		and e:GetHandler()==re:GetHandler()
end
function c575513.fdfilter(c,tp)
	return c:IsCode(575513) and c:CheckUniqueOnField(tp) 
end
function c575513.fieldtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c575513.fdfilter,tp,LOCATION_DECK,0,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c575513.fieldop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(575513,1)) then
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,c575513.fieldop2)
	end
end
function c575513.fieldop2(e,tp,eg,ep,ev,re,r,rp)
	local sc=Duel.GetFirstMatchingCard(c575513.fdfilter,tp,LOCATION_DECK,0,nil,tp)
	if sc and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c575513.movefilter(c)
	return c:IsSetCard(0xc1) and (c:IsType(TYPE_FIELD) or c:IsType(TYPE_CONTINUOUS))
end
function c575513.thfilter(c)
	return c:IsSetCard(0xc1) and c:IsAbleToHand()
end
function c575513.filter1(c,e,tp)
	return c:IsSetCard(0xc1) and c:IsType(TYPE_TUNER)
		and Duel.IsExistingTarget(c575513.filter2,tp,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,e,tp,c:GetLevel())
end
function c575513.filter2(c,e,tp,lv)
	local clv=c:GetLevel()
	return clv>0 and c:IsSetCard(0xc1) and not c:IsType(TYPE_TUNER)
		and Duel.IsExistingMatchingCard(c575513.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv+clv)
end
function c575513.spfilter(c,e,tp,lv)
	return c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c575513.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	return re:GetHandler():IsSetCard(0xc1) and not re:GetHandler():IsCode(575513)
end
function c575513.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c575513.movefilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c575513.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b3=(Duel.GetLocationCountFromEx(tp)>0 and Duel.IsExistingMatchingCard(c575513.filter1,tp,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,e,tp))
	if chk==0 then return b1 or b2 or b3 end
	local op=0
	if b1 and b2 and b3 then
		op=Duel.SelectOption(tp,aux.Stringid(575513,2),aux.Stringid(575513,3),aux.Stringid(575513,4))
	elseif b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(575513,2),aux.Stringid(575513,3))
	elseif b1 and b3 then
		op=Duel.SelectOption(tp,aux.Stringid(575513,2),aux.Stringid(575513,4)) if op==1 then op=2 end 
	elseif b2 and b3 then
		op=Duel.SelectOption(tp,aux.Stringid(575513,3),aux.Stringid(575513,4))+1
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(575513,2))
	elseif b2 then
		op=Duel.SelectOption(tp,aux.Stringid(575513,3))+1
	else op=Duel.SelectOption(tp,aux.Stringid(575513,4))+2 end
	e:SetLabel(op)
	if op==0 then

	elseif op==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else 
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end

function c575513.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(575513,5))
		local tc=Duel.SelectMatchingCard(tp,c575513.movefilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc then
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc and tc:IsType(TYPE_FIELD) then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			if tc:IsType(TYPE_FIELD) then 
				Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			end
			if tc:IsType(TYPE_CONTINUOUS) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then 
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end
		end
	elseif e:GetLabel()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c575513.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc1=Duel.SelectMatchingCard(tp,c575513.filter1,tp,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc2=Duel.SelectMatchingCard(tp,c575513.filter2,tp,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil,e,tp,tc1:GetFirst():GetLevel())
		local sg=Duel.GetMatchingGroup(c575513.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,tc1:GetFirst():GetLevel()+tc2:GetFirst():GetLevel())
		if sg:GetCount()==0 then return end
		tc1:Merge(tc2)
		Duel.SendtoDeck(tc1,nil,2,REASON_EFFECT+REASON_RETURN)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local ssg=sg:Select(tp,1,1,nil)
		Duel.SpecialSummon(ssg,0,tp,tp,false,false,POS_FACEUP)
	end
end