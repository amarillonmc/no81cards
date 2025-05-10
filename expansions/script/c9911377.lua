--雪狱之罪名 危局的叛变
function c9911377.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9911377)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9911377.target)
	e1:SetOperation(c9911377.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9911378)
	e2:SetCondition(c9911377.spcon2)
	e2:SetCost(c9911377.spcost2)
	e2:SetTarget(c9911377.sptg2)
	e2:SetOperation(c9911377.spop2)
	c:RegisterEffect(e2)
	if not c9911377.global_check then
		c9911377.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BECOME_TARGET)
		ge1:SetOperation(c9911377.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9911377.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(Card.IsLocation,nil,LOCATION_GRAVE+LOCATION_REMOVED)
	if #tg>0 then
		for tc in aux.Next(tg) do
			tc:RegisterFlagEffect(9911379,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910212,0))
		end
	end
end
function c9911377.filter1(c,tp)
	return c:IsSetCard(0xc956) and c:IsType(TYPE_MONSTER)
		and Duel.IsExistingTarget(c9911377.filter2,tp,0,LOCATION_GRAVE,1,nil,c:IsAbleToRemove(),c:IsSpecialSummonableCard())
end
function c9911377.filter2(c,b1,b2)
	return c:IsType(TYPE_MONSTER) and ((b1 and c:IsSpecialSummonableCard()) or (b2 and c:IsAbleToRemove()))
end
function c9911377.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c9911377.filter1,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c9911377.filter1,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c9911377.filter2,tp,0,LOCATION_GRAVE,1,1,nil,tc:IsAbleToRemove(),tc:IsSpecialSummonableCard())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,1,0,0)
end
function c9911377.filter3(c,mg)
	return c:IsAbleToRemove() and mg:IsExists(Card.IsSpecialSummonableCard,1,c)
end
function c9911377.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc1=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil,g):GetFirst()
		if tc1 then
			Duel.Remove(tc1,POS_FACEUP,REASON_EFFECT)
			local tc2=g:Filter(Card.IsSpecialSummonableCard,tc1):GetFirst()
			if tc2 then
				local fid=c:GetFieldID()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
				e1:SetCountLimit(1)
				if Duel.GetCurrentPhase()==PHASE_STANDBY then
					e1:SetLabel(fid,Duel.GetTurnCount())
					e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
					tc2:RegisterFlagEffect(9911377,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,0,2,fid)
				else
					e1:SetLabel(fid,0)
					e1:SetReset(RESET_PHASE+PHASE_STANDBY)
					tc2:RegisterFlagEffect(9911377,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,0,1,fid)
				end
				e1:SetLabelObject(tc2)
				e1:SetCondition(c9911377.spcon1)
				e1:SetOperation(c9911377.spop1)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.RegisterFlagEffect(tp,9911378,RESET_PHASE+PHASE_END,0,1)
	end
end
function c9911377.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local lab1,lab2=e:GetLabel()
	return e:GetLabelObject():GetFlagEffectLabel(9911377)==lab1 and Duel.GetTurnCount()~=lab2
end
function c9911377.spop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and aux.NecroValleyFilter()(tc) then
		Duel.Hint(HINT_CARD,0,9911377)
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
		local g=Duel.GetMatchingGroup(c9911377.desfilter,tp,LOCATION_MZONE,0,nil,tc:GetAttribute())
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end
function c9911377.desfilter(c,attr)
	return c:IsFaceup() and c:IsAttribute(attr)
end
function c9911377.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9911378)==0
end
function c9911377.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) and c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c9911377.spfilter(c,e,tp)
	return c:IsFaceupEx() and c:GetFlagEffect(9911379)~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911377.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9911377.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c9911377.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9911377.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
