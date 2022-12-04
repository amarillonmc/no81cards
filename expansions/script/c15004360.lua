local m=15004360
local cm=_G["c"..m]
cm.name="来自苍白星海的故人"
function cm.initial_effect(c)
	--fusion summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	if not cm.global_effect then
		cm.global_effect=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_SYNCHRO_MATERIAL)
		ge1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		ge1:SetCondition(cm.syncon)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SPSUMMON)
		ge2:SetCondition(cm.syncon)
		ge2:SetOperation(cm.spop)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()&(PHASE_DAMAGE+PHASE_DAMAGE_CAL)==0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.syncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,15004360)~=0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(0,15004360)
	Duel.ResetFlagEffect(1,15004360)
end
function cm.filter1(c,e,sc,chkx,tc)
	return c:IsFaceup() and (chkx==0 or (not c:IsImmuneToEffect(e))) and c:IsCanBeSynchroMaterial(sc,tc)
end
function cm.filter2(c,e,tp,chkx,sc)
	local ag=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE):Filter(cm.filter1,nil,e,c,chkx,sc)
	local bg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0):Filter(cm.filter1,nil,e,c,chkx,sc)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and ((c:IsSetCard(0xcf30) and c:IsSynchroSummonable(sc,ag)) or (c:IsSynchroSummonable(sc,bg) and not c:IsSetCard(0xcf30)))
end
--c:IsSynchroSummonable(sc,ag,1,99)
--Duel.CheckSynchroMaterial(c,nil,nil,1,99,sc,ag)
function cm.filter3(c,e)
	return c:IsOnField() and not c:IsImmuneToEffect(e)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		Duel.RegisterFlagEffect(tp,15004360,RESET_CHAIN,0,1)
		Duel.RegisterFlagEffect(1-tp,15004360,RESET_CHAIN,0,1)
		local x=0
		if Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,0,e:GetHandler()) then x=1 end
		Duel.ResetFlagEffect(tp,15004360)
		Duel.ResetFlagEffect(1-tp,15004360)
		return x==1
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,15004360,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(1-tp,15004360,RESET_PHASE+PHASE_END,0,1)
	local g=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local ag=Group.CreateGroup()
		if sg:GetFirst():IsSetCard(0xcf30) then
			ag=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE):Filter(cm.filter1,nil,e,sg:GetFirst(),1,e:GetHandler())
		end
		if not sg:GetFirst():IsSetCard(0xcf30) then
			ag=Duel.GetFieldGroup(tp,LOCATION_MZONE,0):Filter(cm.filter1,nil,e,sg:GetFirst(),1,e:GetHandler())
		end
		Duel.SynchroSummon(tp,sg:GetFirst(),e:GetHandler(),ag)
	end
end