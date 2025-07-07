--宿命的邂逅
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CUSTOM+id)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.postg)
	e1:SetOperation(s.posop)
	c:RegisterEffect(e1)
	local custom_code3=aux.RegisterMergedDelayedEvent_ToSingleCard(c,id,EVENT_DESTROYED)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(custom_code3)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1000)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	local custom_code4=aux.RegisterMergedDelayedEvent_ToSingleCard(c,id,EVENT_REMOVE)
	local e3=e2:Clone()
	e3:SetCode(custom_code4)
	e3:SetTarget(s.sptg2)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		local g=Group.CreateGroup()
		g:KeepAlive()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetLabel(id)
		ge1:SetLabelObject(g)
		ge1:SetOperation(aux.MergedDelayEventCheck1)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(aux.MergedDelayEventCheck2)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge3:Clone()
		ge4:SetCode(EVENT_CHAIN_END)
		ge4:SetOperation(aux.MergedDelayEventCheck2)
		Duel.RegisterEffect(ge4,0)
	end
end
function s.spfilter(c,e,tp,tc)
	return c:GetOriginalRace()~=tc:GetOriginalRace() and c:GetOriginalAttribute()==tc:GetOriginalAttribute() and not c:IsSummonableCard() and Duel.GetLocationCountFromEx(tp,tp,nil,c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.filter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and s.filter(chkc,e,tp) end
	if chk==0 then return eg:IsExists(s.filter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=eg:FilterSelect(tp,s.filter,1,1,nil,e,tp)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and s.filter(tc,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
		local gc=g:GetFirst()
		if gc and Duel.SpecialSummonStep(gc,0,tp,tp,false,false,POS_FACEUP) then
			if gc:IsCode(89490005) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_IMMUNE_EFFECT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetLabelObject(tc)
				e1:SetValue(s.efilter)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				gc:RegisterEffect(e1)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function s.efilter(e,te)
	return te:GetOwner()==e:GetLabelObject()
end
function s.spfilter1(c,e,tp,rp)
	return (c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT)))
		and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_MONSTER)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
		and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c:IsCanBeEffectTarget(e)
		and c:IsAbleToDeck()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and s.spfilter1(chkc,e,tp,rp) end
	if chk==0 then return eg:IsExists(s.spfilter1,1,nil,e,tp,rp) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=eg:FilterSelect(tp,s.spfilter1,1,1,nil,e,tp,rp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not aux.NecroValleyFilter()(tc) then return end
	Duel.SendtoDeck(tc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	if tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function s.spfilter2(c,e,tp)
	return c:IsReason(REASON_EFFECT)
		and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_MONSTER)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
		and c:IsCanBeEffectTarget(e)
		and c:IsAbleToDeck()
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and s.spfilter2(chkc,e,tp) end
	if chk==0 then return eg:IsExists(s.spfilter2,1,nil,e,tp,rp) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=eg:FilterSelect(tp,s.spfilter2,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
