--堕落天国
function c10201003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--race
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_FAIRY)
	c:RegisterEffect(e2)
	local e2g=e2:Clone()
	e2g:SetTargetRange(LOCATION_GRAVE,LOCATION_GRAVE)
	e2g:SetCondition(c10201003.gravecon)
	c:RegisterEffect(e2g)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e3:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e3)
	local e3g=e3:Clone()
	e3g:SetTargetRange(LOCATION_GRAVE,LOCATION_GRAVE)
	e3g:SetCondition(c10201003.gravecon)
	c:RegisterEffect(e3g)
    -- 基本分回复效果
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(10201003,0))
    e4:SetCategory(CATEGORY_RECOVER)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCountLimit(1)
    e4:SetTarget(c10201003.rectg)
    e4:SetOperation(c10201003.recop)
    c:RegisterEffect(e4)
end
-- 1
function c10201003.gravecon(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NECRO_VALLEY)
		and not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_NECRO_VALLEY)
end
-- 2
function c10201003.recfilter(c)
    return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c10201003.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
    local hg=Duel.GetMatchingGroup(c10201003.recfilter,tp,LOCATION_HAND,0,nil)
    local fg=Duel.GetMatchingGroup(c10201003.recfilter,tp,LOCATION_MZONE,0,nil)
    if chk==0 then return #hg>0 or #fg>0 end
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c10201003.recop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local hg=Duel.SelectMatchingCard(tp,c10201003.recfilter,tp,LOCATION_HAND,0,0,99,nil)
    Duel.ConfirmCards(1-tp,hg)
    local fg=Duel.GetMatchingGroup(c10201003.recfilter,tp,LOCATION_MZONE,0,nil)
    local total=#hg+#fg
    if total>0 then
        Duel.Recover(tp,total*1000,REASON_EFFECT)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetCountLimit(1)
        e1:SetReset(RESET_PHASE+PHASE_END)
        e1:SetOperation(c10201003.shufflehandop)
        Duel.RegisterEffect(e1,tp)
    end
end
function c10201003.shufflehandop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ShuffleHand(tp)
end
