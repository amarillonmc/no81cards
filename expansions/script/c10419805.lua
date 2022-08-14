--缩小药水
local m=10419805
local cm=_G["c"..m]
cm.named_with_Potion=1
function cm.Kabal(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Kabal
end
function cm.Potion(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Potion
end

function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Activate2
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(m,1))
	e10:SetCategory(CATEGORY_DEFCHANGE)
	e10:SetType(EFFECT_TYPE_ACTIVATE)
	e10:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetCondition(cm.conditiont)
	e10:SetTarget(cm.targett)
	e10:SetOperation(cm.activatet)
	c:RegisterEffect(e10)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(cm.actcon)
	c:RegisterEffect(e2)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,3))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCondition(cm.spcon)
	e5:SetCost(aux.bfgcost)
	e5:SetTarget(cm.sptg)
	e5:SetOperation(cm.spop)
	c:RegisterEffect(e5)
end
function cm.cfilter(c,tp)
	return cm.Kabal(c) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) and  c:GetReasonPlayer()==1-tp
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function cm.spfilter(c,e,tp)
	return cm.Kabal(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and c:IsLevelBelow(Duel.GetTurnCount())
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local rg=Duel.GetReleaseGroup(tp)
		rg:RemoveCard(g:GetFirst())
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and rg:GetCount()~=0 then
			Duel.BreakEffect()
			Duel.Release(g,REASON_EFFECT)
		end
	end
end

function cm.actfilter(c)
	return c:IsFaceup() and cm.Kabal(c)
end
function cm.actcon(e,tp)
	local tp=e:GetHandler():GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1
		and Duel.IsExistingMatchingCard(cm.actfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.condition(e,tp)
	return Duel.GetTurnCount()<6 or (Duel.IsPlayerAffectedByEffect(tp,10419902) and Duel.GetFlagEffect(tp,10419902)==0)
end
function cm.thfilter(c)
	return c:IsType(TYPE_MONSTER) and cm.Kabal(c) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) and cm.TargetReflect1(e,tp,eg,ep,ev,re,r,rp,0)
	   and cm.TargetReflect2(e,tp,eg,ep,ev,re,r,rp,0) 
	   and cm.TargetReflect3(e,tp,eg,ep,ev,re,r,rp,0) 
	   and cm.TargetReflect4(e,tp,eg,ep,ev,re,r,rp,0) 
	   and cm.TargetReflect5(e,tp,eg,ep,ev,re,r,rp,0) end
	if Duel.GetTurnCount()>=6 then Duel.RegisterFlagEffect(tp,10419902,RESET_PHASE+PHASE_END,0,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	cm.TargetReflect1(e,tp,eg,ep,ev,re,r,rp,chk)
	cm.TargetReflect2(e,tp,eg,ep,ev,re,r,rp,chk)
	cm.TargetReflect3(e,tp,eg,ep,ev,re,r,rp,chk)
	cm.TargetReflect4(e,tp,eg,ep,ev,re,r,rp,chk)
	cm.TargetReflect5(e,tp,eg,ep,ev,re,r,rp,chk)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
	cm.ActivateReflect1(e,tp,eg,ep,ev,re,r,rp)
	cm.ActivateReflect2(e,tp,eg,ep,ev,re,r,rp)
	cm.ActivateReflect3(e,tp,eg,ep,ev,re,r,rp)
	cm.ActivateReflect4(e,tp,eg,ep,ev,re,r,rp)
	cm.ActivateReflect5(e,tp,eg,ep,ev,re,r,rp)
end
function cm.conditiont(e,tp)
	return Duel.GetTurnCount()>=6 or (Duel.IsPlayerAffectedByEffect(tp,10419902) and Duel.GetFlagEffect(tp,10419902)==0)
end
function cm.filtert(c)
	return c:IsPosition(POS_FACEUP) and not (c:IsRace(RACE_DRAGON) or cm.Kabal(c))
end
function cm.filtert2(c)
	return c:IsPosition(POS_FACEUP) and not c:IsDefenseAbove(1)
end
function cm.targett(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filtert,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and cm.TargetReflect1(e,tp,eg,ep,ev,re,r,rp,0)
	   and cm.TargetReflect2(e,tp,eg,ep,ev,re,r,rp,0) 
	   and cm.TargetReflect3(e,tp,eg,ep,ev,re,r,rp,0) 
	   and cm.TargetReflect4(e,tp,eg,ep,ev,re,r,rp,0) 
	   and cm.TargetReflect5(e,tp,eg,ep,ev,re,r,rp,0) end
	if Duel.GetTurnCount()<6 then Duel.RegisterFlagEffect(tp,10419902,RESET_PHASE+PHASE_END,0,1) end
	cm.TargetReflect1(e,tp,eg,ep,ev,re,r,rp,chk)
	cm.TargetReflect2(e,tp,eg,ep,ev,re,r,rp,chk)
	cm.TargetReflect3(e,tp,eg,ep,ev,re,r,rp,chk)
	cm.TargetReflect4(e,tp,eg,ep,ev,re,r,rp,chk)
	cm.TargetReflect5(e,tp,eg,ep,ev,re,r,rp,chk)
end
function cm.activatet(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filtert,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(-2500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	local sg=Duel.GetMatchingGroup(cm.filtert2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Destroy(sg,REASON_EFFECT)
	end
	cm.ActivateReflect1(e,tp,eg,ep,ev,re,r,rp)
	cm.ActivateReflect2(e,tp,eg,ep,ev,re,r,rp)
	cm.ActivateReflect3(e,tp,eg,ep,ev,re,r,rp)
	cm.ActivateReflect4(e,tp,eg,ep,ev,re,r,rp)
	cm.ActivateReflect5(e,tp,eg,ep,ev,re,r,rp)
end

-------------------Extra Effect---------------------


--Pot
function cm.TargetReflect1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if c:GetFlagEffect(10419701)~=0 then return cm.target1(e,tp,eg,ep,ev,re,r,rp,chk) end
	if chk==0 then return true end
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.ActivateReflect1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(10419701)~=0 then return cm.activate1(e,tp,eg,ep,ev,re,r,rp)end
end
function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10419701)
	Duel.BreakEffect()
	Duel.Draw(tp,2,REASON_EFFECT)
end

--Thunder
function cm.TargetReflect2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if c:GetFlagEffect(10419702)~=0 then return cm.target2(e,tp,eg,ep,ev,re,r,rp,chk) end
	if chk==0 then return true end
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function cm.ActivateReflect2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(10419702)~=0 then return cm.activate2(e,tp,eg,ep,ev,re,r,rp)end
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10419702)
	Duel.BreakEffect()
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end

--Feather sweep
function cm.TargetReflect3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if c:GetFlagEffect(10419703)~=0 then return cm.target3(e,tp,eg,ep,ev,re,r,rp,chk) end
	if chk==0 then return true end
end
function cm.filter3(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter3,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(cm.filter3,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function cm.ActivateReflect3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(10419703)~=0 then return cm.activate3(e,tp,eg,ep,ev,re,r,rp)end
end
function cm.activate3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10419703)
	Duel.BreakEffect()
	local sg=Duel.GetMatchingGroup(cm.filter3,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.Destroy(sg,REASON_EFFECT)
end

--Handes
function cm.TargetReflect4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if c:GetFlagEffect(10419704)~=0 then return cm.target4(e,tp,eg,ep,ev,re,r,rp,chk) end
	if chk==0 then return true end
end
function cm.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function cm.ActivateReflect4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(10419704)~=0 then return cm.activate4(e,tp,eg,ep,ev,re,r,rp)end
end
function cm.activate4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10419704)
	Duel.BreakEffect()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(1-tp,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	end
end

--Heal
function cm.TargetReflect5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if c:GetFlagEffect(10419705)~=0 then return cm.target5(e,tp,eg,ep,ev,re,r,rp,chk) end
	if chk==0 then return true end
end
function cm.target5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(5000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,5000)
end
function cm.ActivateReflect5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(10419705)~=0 then return cm.activate5(e,tp,eg,ep,ev,re,r,rp)end
end
function cm.activate5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10419705)
	Duel.BreakEffect()
	Duel.Recover(tp,5000,REASON_EFFECT)
end



