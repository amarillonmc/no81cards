--地神之母
function c43990982.initial_effect(c)
	aux.AddCodeList(c,43990987)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(43990982,2))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c43990982.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43990982,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c43990982.target)
	e1:SetOperation(c43990982.activate)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetDescription(aux.Stringid(43990982,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	--e2:SetCountLimit(1,43990982)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c43990982.rmtg)
	e2:SetOperation(c43990982.rmop)
	c:RegisterEffect(e2)
end
function c43990982.hcfilter(c)
	return c:IsRace(RACE_ILLUSION) and c:IsFaceup()
end
function c43990982.cfilter(c)
	return c:IsCode(43990987) and c:IsFaceup()
end
function c43990982.handcon(e)
	return not Duel.IsExistingMatchingCard(c43990982.hcfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) or Duel.IsExistingMatchingCard(c43990982.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c43990982.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() and Duel.GetMZoneCount(tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,43990982,0,TYPES_NORMAL_TRAP_MONSTER,2000,2400,4,RACE_ILLUSION,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c43990982.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.IsPlayerCanSpecialSummonMonster(tp,43990982,0,TYPES_NORMAL_TRAP_MONSTER,2000,2400,4,RACE_ILLUSION,ATTRIBUTE_DARK) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c43990982.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return g:CheckSubGroup(aux.gfcheck,2,2,Card.IsControler,0,1) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,LOCATION_MZONE)
end
function c43990982.rfilter(c)
	return c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT)
end
function c43990982.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,aux.gfcheck,false,2,2,Card.IsControler,0,1)
	if sg:GetCount()==0 then return end
	Duel.HintSelection(sg)
	if Duel.Remove(sg,0,REASON_EFFECT+REASON_TEMPORARY)==0 then return end
	local og=Duel.GetOperatedGroup():Filter(c43990982.rfilter,nil)
	if #og==0 then return end
	for tc in aux.Next(og) do
		tc:RegisterFlagEffect(43990982,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
	og:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetLabelObject(og)
	e1:SetCountLimit(1)
	e1:SetCondition(c43990982.retcon)
	e1:SetOperation(c43990982.retop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c43990982.retfilter(c,tp)
	return c:GetFlagEffect(43990982)~=0 and (not tp or c:IsControler(tp))
end
function c43990982.retcon(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetLabelObject():IsExists(c43990982.retfilter,1,nil,nil) then
		e:GetLabelObject():DeleteGroup()
		e:Reset()
		return false
	end
	return true
end
function c43990982.returngroup(g,tp)
	if #g==0 then return end
	local tc
	while #g>1 and Duel.GetMZoneCount(tp)>0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.ReturnToField(tc)
		g=g-tc
	end
	for oc in aux.Next(g) do
		Duel.ReturnToField(oc)
	end
end
function c43990982.retop(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	local g1=e:GetLabelObject():Filter(c43990982.retfilter,nil,turnp)
	local g2=e:GetLabelObject():Filter(c43990982.retfilter,nil,1-turnp)
	if #g1+#g2==0 then return end
	c43990982.returngroup(g1,turnp)
	c43990982.returngroup(g2,1-turnp)
end
