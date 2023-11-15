--出 云 之 神 -天 夷 鸟
local m=130006044
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,3,3,c130006044.lcheck)
	c:EnableReviveLimit()
	aux.AddCodeList(c,130006046)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c130006044.limcon)
	e1:SetOperation(c130006044.limop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetOperation(c130006044.limop2)
	c:RegisterEffect(e2)
	--sp th sc
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c130006044.rstg)
	e3:SetOperation(c130006044.rsop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetOperation(c130006044.checkop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetOperation(c130006044.stop)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	--special Summon
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e6:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e6:SetCondition(c130006044.spcon)
	e6:SetCost(aux.bfgcost)
	e6:SetTarget(c130006044.sptg)
	e6:SetOperation(c130006044.spop)
	c:RegisterEffect(e6)
	
end
function c130006044.spcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return false end
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2
end
function c130006044.filter(c,e,tp)
	return aux.IsCodeListed(c,130006046) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c130006044.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c130006044.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c130006044.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c130006044.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c130006044.rstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_DECK,nil)
	g1:Merge(g2)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c130006044.rsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_DECK,nil)
	local b1=g1:GetCount()>0
	local b2=g2:GetCount()>0
	if b1 and b2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg2=g2:Select(1-tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.Remove(sg1,POS_FACEDOWN,REASON_EFFECT)
		local sgg=Duel.GetOperatedGroup()
		local tc=sgg:GetFirst()
		while c:IsRelateToEffect(e) and tc do
			c:SetCardTarget(tc)
			tc=sgg:GetNext()
		end
	end
end
function c130006044.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c130006044.stop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetLabel()~=0 then return end
	local g=e:GetHandler():GetCardTarget()
	local rc=g:GetFirst()
	while rc do
	local tpp=rc:GetControler()
		if rc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(1-tpp,LOCATION_MZONE)>0 then
			Duel.SpecialSummon(rc,0,1-tpp,1-tpp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(tpp,rc)
		elseif (rc:IsType(TYPE_FIELD) or Duel.GetLocationCount(1-tpp,LOCATION_SZONE)>0)
			and rc:IsSSetable(true) then
			Duel.SSet(1-tpp,rc)
		end
		rc=g:GetNext()
	end
end
function c130006044.lcheck(g)
	return g:GetClassCount(Card.GetLinkRace)==g:GetCount()
end
function c130006044.limfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsType(TYPE_LINK)
end
function c130006044.limcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c130006044.limfilter,1,nil,tp)
end
function c130006044.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(c130006044.chainlm)
	elseif Duel.GetCurrentChain()==1 then
		e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(c130006044.resetop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_BREAK_EFFECT)
		e2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
	end
end
function c130006044.resetop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(id)
	e:Reset()
end
function c130006044.limop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(id)~=0 then
		Duel.SetChainLimitTillChainEnd(c130006044.chainlm)
	end
	e:GetHandler():ResetFlagEffect(id)
end
function c130006044.chainlm(e,rp,tp)
	return tp==rp
end