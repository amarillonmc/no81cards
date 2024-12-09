--极简升级
function c65850070.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65850070+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c65850070.target)
	e1:SetOperation(c65850070.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(c65850070.excondition)
	e0:SetDescription(aux.Stringid(65850070,0))
	c:RegisterEffect(e0)
end


function c65850070.cfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsDiscardable()
end
function c65850070.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65850070.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c65850070.cfilter,1,1,REASON_DISCARD+REASON_COST,nil)
end
function c65850070.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,65850070,0xa35,TYPES_EFFECT_TRAP_MONSTER,0,0,2,RACE_MACHINE,ATTRIBUTE_LIGHT,POS_FACEUP,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65850070.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65850070.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,65850070,0xa35,TYPES_EFFECT_TRAP_MONSTER,0,0,2,RACE_MACHINE,ATTRIBUTE_LIGHT,POS_FACEUP,tp) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)>0 and Duel.SelectYesNo(tp,aux.Stringid(65850070,1)) then 
			if c:IsControler(1-tp) or c:IsFacedown() then return end
			Duel.BreakEffect()
			local g=Duel.GetMatchingGroup(c65850070.lkfilter,tp,LOCATION_EXTRA,0,nil,nil,c)
			if g:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,1,1,nil)
				Duel.LinkSummon(tp,sg:GetFirst(),nil,c)
			end
		end
	end
end
function c65850070.lkfilter(c,lc)
	return c:IsSetCard(0xa35) and c:IsLinkSummonable(nil,lc)
end
function c65850070.splimit(e,c)
	return not c:IsSetCard(0xa35)
end
function c65850070.cfilter(c)
	return c:IsSetCard(0xa35) and c:IsFaceup()
end
function c65850070.excondition(e)
	local ct=Duel.GetCurrentChain()
	if not (ct and ct>0) then return end
	local rp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_PLAYER)
	local tp=e:GetHandlerPlayer()
	return rp~=tp and (Duel.IsExistingMatchingCard(c65850070.cfilter,tp,LOCATION_MZONE,0,1,nil) or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0)
end