local m=53739012
local cm=_G["c"..m]
cm.name="异金次元秽魔导 德雷恩"
function cm.initial_effect(c)
	c:EnableCounterPermit(0x1)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,4,true)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.postg)
	e1:SetOperation(cm.posop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.rvcon)
	e2:SetTarget(cm.rvtg)
	e2:SetOperation(cm.rvop)
	c:RegisterEffect(e2)
end
function cm.ffilter(c)
	return c:IsFusionSetCard(0x6e) or c:IsRace(RACE_ROCK)
end
function cm.lfilter(c)
	return c:GetSequence()>4
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,0,nil)
	local og=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)
	local ag=Group.__add(g,og)
	local exg=ag:Filter(cm.lfilter,nil)
	if chk==0 then return #g>0 and #ag>1 and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>#exg-1 end
	local ch=Duel.GetCurrentChain()
	if ch>1 and Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_PLAYER)~=tp and e:GetHandler():GetCounter(0x1)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local ct=e:GetHandler():GetCounter(0x1)
		e:GetHandler():RemoveCounter(tp,0x1,ct,REASON_COST)
		e:SetLabel(ct)
	end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,0,nil):Filter(aux.NOT(Card.IsImmuneToEffect),nil,e)
	local og=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)
	local ag=Group.__add(g,og)
	local exg=ag:Filter(cm.lfilter,nil)
	if #g<1 or #ag<2 or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<#exg then return end
	if Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)==0 then return end
	for tc in aux.Next(exg) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		Duel.Hint(HINT_ZONE,tp,fd)
		Duel.MoveSequence(tc,math.log(fd,2))
	end
	Duel.ShuffleSetCard(Duel.GetMatchingGroup(aux.NOT(cm.lfilter),tp,LOCATION_MZONE,0,nil):Filter(Card.IsFacedown,nil))
	local ct=e:GetLabel()
	if ct==0 then return end
	Duel.BreakEffect()
	local ch=Duel.GetCurrentChain()
	local cg=Group.CreateGroup()
	Duel.ChangeTargetCard(ch-1,cg)
	Duel.ChangeChainOperation(ch-1,cm.repop(ct))
end
function cm.repop(ct)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local dct=math.min(#g,ct)
		local sg=g:Select(tp,dct,dct,nil)
		if sg:GetCount()>0 then
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end
function cm.rvcon(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(e:GetHandler():GetPreviousControler())
	return bit.band(r,REASON_DESTROY)~=0
		and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
		and e:GetHandler():IsPreviousPosition(POS_FACEDOWN)
end
function cm.rvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function cm.rvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local batk=c:GetBaseAttack()
	local bdef=c:GetBaseDefense()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(bdef)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(batk)
		c:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
		if not c:IsLocation(LOCATION_MZONE) or c:IsFacedown() then return end
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_MSET)
		e3:SetRange(LOCATION_MZONE)
		e3:SetOperation(cm.ctop)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e3)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
		local e4=e3:Clone()
		e4:SetCode(EVENT_SSET)
		c:RegisterEffect(e4)
		local e5=e3:Clone()
		e5:SetCode(EVENT_CHANGE_POS)
		e5:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return eg:IsExists(Card.IsFacedown,1,nil)end)
		c:RegisterEffect(e5)
		local e6=e5:Clone()
		e6:SetCode(EVENT_SPSUMMON_SUCCESS)
		c:RegisterEffect(e6)
		if rp~=tp and tp==e:GetLabel() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
			local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1,1)
end
