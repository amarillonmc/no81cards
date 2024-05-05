--拨动紫炎蔷薇的曲调
function c9911560.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--to deck & spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,9911560)
	e1:SetTarget(c9911560.tdtg)
	e1:SetOperation(c9911560.tdop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9911561)
	e2:SetCondition(c9911560.setcon)
	e2:SetTarget(c9911560.settg)
	e2:SetOperation(c9911560.setop)
	c:RegisterEffect(e2)
	--to hand/remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,9911562)
	e3:SetTarget(c9911560.thtg)
	e3:SetOperation(c9911560.thop)
	c:RegisterEffect(e3)
	if not c9911560.global_check then
		c9911560.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c9911560.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9911560.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsReason(REASON_COST) and re:IsActivated() and re:GetHandler():IsType(TYPE_PENDULUM) then
			tc:RegisterFlagEffect(9911560,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911560,1))
		end
		tc=eg:GetNext()
	end
end
function c9911560.costfilter(c)
	return c:IsSetCard(0x6952) and c:IsAbleToGraveAsCost()
end
function c9911560.spfilter(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911560.gselect(g)
	return g:GetClassCount(Card.GetLocation)==#g
end
function c9911560.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c9911560.costfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsExistingMatchingCard(c9911560.costfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c9911560.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c9911560.costfilter,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c9911560.costfilter,tp,LOCATION_DECK,0,nil)
	if b1 then
		g:Merge(g1)
	end
	if b2 then
		g:Merge(g2)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c9911560.gselect,false,1,2)
	local lab=0
	local cat=0
	if sg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then
		lab=lab+LOCATION_HAND
		cat=cat+CATEGORY_TODECK
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_ONFIELD)
	end
	if sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
		lab=lab+LOCATION_DECK
		cat=cat+CATEGORY_SPECIAL_SUMMON
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	end
	e:SetLabel(lab)
	e:SetCategory(cat)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c9911560.tdop(e,tp,eg,ep,ev,re,r,rp)
	local chk
	local lab=e:GetLabel()
	if lab&LOCATION_HAND~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if #g1>0 then
			Duel.HintSelection(g1)
			Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			chk=true
		end
	end
	if lab&LOCATION_DECK~=0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c9911560.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if #g2>0 then
			if chk then Duel.BreakEffect() end
			Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c9911560.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()>1 and eg:IsContains(e:GetHandler())
end
function c9911560.setfilter(c)
	return c:IsSetCard(0x6952) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c9911560.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9911560.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c9911560.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c9911560.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
function c9911560.thfilter(c,tp)
	if c:GetFlagEffect(9911560)==0 then return false end
	return c:IsAbleToHand() or c9911560.rmfilter(c,tp)
end
function c9911560.rmfilter(c,tp)
	return c:IsAbleToRemove() and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
end
function c9911560.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9911560.thfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9911560.thfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c9911560.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c9911560.ogfilter(c)
	return c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT)
end
function c9911560.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if aux.NecroValleyNegateCheck(tc) then return end
		if not aux.NecroValleyFilter()(tc) then return end
		if tc:IsAbleToHand() and (not c9911560.rmfilter(tc,tp) or Duel.SelectOption(tp,1190,aux.Stringid(9911560,0))==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		elseif c9911560.rmfilter(tc,tp) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(g)
			g:AddCard(tc)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			local og=Duel.GetOperatedGroup():Filter(c9911560.ogfilter,nil)
			if #og==0 then return end
			for sc in aux.Next(og) do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
				e1:SetTarget(c9911560.distg)
				e1:SetLabelObject(sc)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_CHAIN_SOLVING)
				e2:SetCondition(c9911560.discon)
				e2:SetOperation(c9911560.disop)
				e2:SetLabelObject(sc)
				e2:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e2,tp)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_FIELD)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
				e3:SetTarget(c9911560.distg)
				e3:SetLabelObject(sc)
				e3:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e3,tp)
			end
		end
	end
end
function c9911560.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c9911560.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c9911560.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
