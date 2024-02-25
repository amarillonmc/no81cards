--インヴェルズの悪細胞
function c49811146.initial_effect(c)
	--link summon
	c:SetSPSummonOnce(49811146)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c49811146.matfilter,1,1)
	--double attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(49811146,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c49811146.condition)
	e1:SetTarget(c49811146.target)
	e1:SetOperation(c49811146.operation)
	c:RegisterEffect(e1)
	--to extra
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49811146,1))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c49811146.dmcon)
	e2:SetTarget(c49811146.dmtarget)
	e2:SetCost(c49811146.dmcost)
	e2:SetOperation(c49811146.dmop)
	c:RegisterEffect(e2)
end
function c49811146.matfilter(c)
	return c:IsLinkSetCard(0x100a) and c:IsLevelBelow(4)
end
function c49811146.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and aux.bpcon()
end
function c49811146.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x100a) and c:IsLevelAbove(5) and not c:IsHasEffect(EFFECT_EXTRA_ATTACK)
end
function c49811146.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c49811146.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c49811146.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c49811146.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c49811146.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end
function c49811146.dmcon(e,tp,eg,ep,ev,re,r,rp)
    local tn=Duel.GetTurnPlayer()
    local ph=Duel.GetCurrentPhase()
    return tn~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c49811146.dmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function c49811146.dmfilter(c)
    return (c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)) and c:IsSetCard(0x100a)
end
function c49811146.dmtarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c49811146.dmfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c49811146.dmop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
    local g=Duel.SelectMatchingCard(tp,c49811146.dmfilter,tp,LOCATION_HAND,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        local s1=tc:IsSummonable(true,nil,1)
        local s2=tc:IsMSetable(true,nil,1)
        if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
            Duel.Summon(tp,tc,true,nil,1)
        else
            Duel.MSet(tp,tc,true,nil,1)
        end
    end
end