local m=82224058
local cm=_G["c"..m]
cm.name="同调加速"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1)  
	--synchro summon  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE)  
	e2:SetCode(EVENT_FREE_CHAIN)   
	e2:SetRange(LOCATION_FZONE)  
	e2:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e2:SetCondition(cm.sccon)
	e2:SetCost(cm.cost)  
	e2:SetTarget(cm.sctg)  
	e2:SetOperation(cm.scop)  
	c:RegisterEffect(e2) 
end
function cm.sccon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckLPCost(tp,1000) end  
	Duel.PayLPCost(tp,1000)  
end  
function cm.sctg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then  
		local mg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)  
		return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg)  
	end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)  
	Duel.SetChainLimit(aux.FALSE)  
end  
function cm.scop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	local mg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)  
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)  
	if g:GetCount()>0 then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
		local sg=g:Select(tp,1,1,nil)  
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)  
	end  
end  