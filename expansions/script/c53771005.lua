--彷徨的蚀茧者
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function c53771005.initial_effect(c)
	SNNM.Sarcoveil_Sort(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetDescription(aux.Stringid(53771005,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,53771005)
	e1:SetCost(c53771005.rmcost)
	e1:SetTarget(c53771005.rmtg)
	e1:SetOperation(c53771005.rmop)
	c:RegisterEffect(e1)
	--spsummon-self
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(53771005,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	--e2:SetTarget(c53771005.spstg)
	e2:SetOperation(c53771005.spsop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,53771006)
	e3:SetCondition(c53771005.spscon)
	c:RegisterEffect(e3)
	c53771005.gravetop_effect=e2
end
function c53771005.costfilter(c)
	return c:IsSetCard(0xa53b) and c:IsAbleToGraveAsCost()
end
function c53771005.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53771005.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c53771005.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c53771005.rmfilter(c)
	return c:GetSequence()<5 and c:IsAbleToRemove()
end
function c53771005.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c53771005.rmfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function c53771005.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c53771005.rmfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()~=0 and Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY)~=0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) then
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		local fid=e:GetHandler():GetFieldID()
		for tc in aux.Next(og) do
			tc:RegisterFlagEffect(53771005,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(53771005,1))
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetLabel(fid)
		e1:SetLabelObject(og)
		e1:SetCountLimit(1)
		e1:SetCondition(c53771005.retcon)
		e1:SetOperation(c53771005.retop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local ft=Duel.GetMZoneCount(tp)
		if ft>0 and Duel.SelectYesNo(tp,aux.Stringid(53771005,2)) then
			Duel.BreakEffect()
			if #og>ft then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
				og=og:Select(tp,ft,ft,nil)
			end
			for tc in aux.Next(og) do Duel.ReturnToField(tc,POS_FACEDOWN_DEFENSE) end
			Duel.ShuffleSetCard(og)
		end
	end
end
function c53771005.retfilter(c,fid)
	return c:GetFlagEffectLabel(53771005)==fid
end
function c53771005.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():IsExists(c53771005.retfilter,1,nil,e:GetLabel())
end
function c53771005.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(c53771005.retfilter,nil,e:GetLabel())
	for tc in aux.Next(g) do Duel.ReturnToField(tc) end
	e:GetLabelObject():DeleteGroup()
end
function c53771005.spscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)==e:GetHandler()
end
function c53771005.spsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_REMOVED,0,1,nil)
	local b2=c:IsRelateToChain() and c:IsLocation(LOCATION_GRAVE) and Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	if not (b1 or b2) then return end
	Duel.Hint(HINT_CARD,0,53771005)
	if b1 and (not b2 or Duel.SelectOption(tp,1190,1152)==0) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_REMOVED,0,1,1,nil):GetFirst()
		tc:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	else
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
