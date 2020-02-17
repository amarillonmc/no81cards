--神树勇者的封印结界
function c9910321.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,9910321+EFFECT_COUNT_CODE_OATH)
	e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e0:SetTarget(c9910321.target)
	e0:SetOperation(c9910321.activate)
	c:RegisterEffect(e0)
	--act in hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(c9910321.handcon)
	c:RegisterEffect(e1)
	--cannot be battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c9910321.condition)
	e2:SetValue(c9910321.atlimit)
	c:RegisterEffect(e2)
	--activate limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c9910321.counterop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(0,1)
	e4:SetCondition(c9910321.condition2)
	e4:SetValue(c9910321.aclimit)
	c:RegisterEffect(e4)
end
function c9910321.handcon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c9910321.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND)
	local c=e:GetHandler()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c9910321.descon)
	e1:SetOperation(c9910321.desop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	c:SetTurnCounter(0)
	c:RegisterEffect(e1)
end
function c9910321.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c9910321.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==1 and c:IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.Destroy(c,REASON_RULE)
	elseif ct==2 then
		Duel.Destroy(c,REASON_RULE)
	end
end
function c9910321.spfilter(c,e,tp)
	return c:IsSetCard(0x956) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910321.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local cg=Duel.GetMatchingGroup(c9910321.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>2 then ft=2 end
	if cg:GetCount()>0 and ft>0 and Duel.SelectYesNo(tp,aux.Stringid(9910321,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=cg:Select(tp,1,ft,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9910321.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x956)
end
function c9910321.condition(e)
	return Duel.IsExistingMatchingCard(c9910321.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,nil)
end
function c9910321.atlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0x956)
end
function c9910321.counterop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep~=tp and re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE then
		local flag=c:GetFlagEffectLabel(9910321)
		if flag then
			c:SetFlagEffectLabel(9910321,flag+1)
		else
			c:RegisterFlagEffect(9910321,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,1)
		end
	end
end
function c9910321.condition2(e)
	local ct=e:GetHandler():GetFlagEffectLabel(9910321)
	return ct and ct>=2 and Duel.IsExistingMatchingCard(c9910321.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,nil)
end
function c9910321.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE 
end
