--假面的舞踏会
function c60159909.initial_effect(c)
	c:SetUniqueOnField(1,1,60159909)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60159909)
    e1:SetHintTiming(0,0x1c0)
    c:RegisterEffect(e1)
	--adjust
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetCode(EVENT_ADJUST)
    e2:SetRange(LOCATION_SZONE)
    e2:SetOperation(c60159909.adjustop)
    c:RegisterEffect(e2)
	--disable spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(1,1)
    e3:SetTarget(c60159909.splimit)
    c:RegisterEffect(e3)
	--
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(60159909,0))
    e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_BOTH_SIDE)
    e4:SetRange(LOCATION_SZONE)
	e4:SetHintTiming(0,0x1c0)
	e4:SetCondition(c60159909.atcon)
    e4:SetTarget(c60159909.attg)
    e4:SetOperation(c60159909.atop)
    c:RegisterEffect(e4)
    local g=Group.CreateGroup()
    g:KeepAlive()
    e2:SetLabelObject(g)
    e3:SetLabelObject(g)
end
function c60159909.attfilter(c,att,tp)
    return c:GetAttribute()==att and c:IsControler(tp)
end
function c60159909.splimit(e,c,sump,sumtype,sumpos,targetp)
    local att=c:GetAttribute()
    return e:GetLabelObject():IsExists(c60159909.attfilter,1,nil,att,sump)
end
function c60159909.adjustop(e,tp,eg,ep,ev,re,r,rp)
    local phase=Duel.GetCurrentPhase()
    if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    e:GetLabelObject():Clear()
    e:GetLabelObject():Merge(g)
end
function c60159909.atcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c60159909.attg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,562)
    local rc=Duel.AnnounceAttribute(tp,1,0xffff)
    e:SetLabel(rc)
end
function c60159909.atop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
        e1:SetValue(e:GetLabel())
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        tc=g:GetNext()
    end
end