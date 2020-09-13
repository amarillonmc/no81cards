--天罗水将 兰布罗斯
function c40009138.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1)
	c:EnableReviveLimit()  
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c40009138.effcon2)
	e3:SetOperation(c40009138.spsumsuc)
	c:RegisterEffect(e3)
	--todeck
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(40009138,0))
	e5:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetCountLimit(1)
	e5:SetCondition(c40009138.condition)
	e5:SetTarget(c40009138.tdtg)
	e5:SetOperation(c40009138.tdop)
	c:RegisterEffect(e5)

	
end
function c40009138.effcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c40009138.spsumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c40009138.chlimit)
	local ph=Duel.GetCurrentPhase()
	if e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and (ph>PHASE_MAIN1 and ph<PHASE_MAIN2)
	then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(aux.TRUE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	end
end
function c40009138.chlimit(e,ep,tp)
	return tp==ep
end
function c40009138.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattledCount(tp)>5 
end
function c40009138.tdfilter(c)
	return   c:IsAbleToDeck()
end
function c40009138.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c40009138.tdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c40009138.filter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40009138.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c40009138.tdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e))
	Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
	--
	Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
	Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,2)
	Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,2)
	Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_EP)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN)
	Duel.RegisterEffect(e2,tp)
	local g2=Duel.GetMatchingGroup(c40009138.filter,tp,LOCATION_DECK,0,nil)
		if #g1>0 and #g2>0 then
			local sg1=g1:Select(tp,1,#g2,nil)
			if sg1:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
				local og1=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_DECK)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local ct=0
				if og1 and og1~=nil then
					ct=og1:GetCount()
					local sg2=Duel.SelectMatchingCard(tp,c40009138.filter,tp,LOCATION_DECK,0,ct,ct,nil,e,tp)
					Duel.SpecialSummon(sg2,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end






end


