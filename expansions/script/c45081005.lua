--跃升叛逆超量龙
local s,id=GetID()
function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_DESTROY_REPLACE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(s.desreptg)
    e1:SetValue(s.desrepval)
    e1:SetOperation(s.desrepop)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(s.dcon)
    e2:SetValue(aux.tgoval)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetValue(aux.indoval)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetCondition(s.regcon)
    e4:SetOperation(s.regop)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_MATERIAL_CHECK)
    e5:SetValue(s.valcheck)
    e5:SetLabelObject(e4)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,0))
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetCode(EVENT_FREE_CHAIN)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1,id)
    e6:SetCondition(s.effcon)
    e6:SetCost(s.cost)
    e6:SetOperation(s.operation)
    c:RegisterEffect(e6)
end
function s.dcon(e)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.repfilter(c,tp)
    return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
        and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return eg:IsExists(s.repfilter,1,nil,tp)
        and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
    return Duel.SelectEffectYesNo(tp,c,96)
end
function s.desrepval(e,c)
    return s.repfilter(c,e:GetHandlerPlayer())
end
function s.desrepop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
    Duel.Hint(HINT_CARD,0,id)
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetLabel()==1
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
    c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
end
function s.effcon(e)
    return e:GetHandler():GetFlagEffect(id)>0 and Duel.GetMatchingGroupCount(aux.NegateMonsterFilter,tp,0,LOCATION_ONFIELD,nil)>0
end
function s.filter(c)
    return c:IsSetCard(0x2073) and c:IsType(TYPE_XYZ)
end
function s.valcheck(e,c)
    local g=c:GetMaterial()
    if g:IsExists(s.filter,1,nil) then
        e:GetLabelObject():SetLabel(1)
    else
        e:GetLabelObject():SetLabel(0)
    end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,nil)
    for tc in aux.Next(g) do
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_DISABLE_EFFECT)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e3)
end
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local atk=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil):GetSum(Card.GetBaseAttack)
        if atk>0 then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
            e1:SetValue(atk)
            c:RegisterEffect(e1)
        end
    end
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e5:SetCode(EVENT_ATTACK_ANNOUNCE)
    e5:SetReset(RESET_PHASE+PHASE_END)
    e5:SetOperation(s.checkop)
    Duel.RegisterEffect(e5,tp)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e4:SetReset(RESET_PHASE+PHASE_END)
    e4:SetCondition(s.atkcon)
    e4:SetTarget(s.atktg)
    e5:SetLabelObject(e4)
    Duel.RegisterEffect(e4,tp)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFlagEffect(tp,id)~=0 then return end
    local fid=eg:GetFirst():GetFieldID()
    Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
    e:GetLabelObject():SetLabel(fid)
end
function s.atkcon(e)
    return Duel.GetFlagEffect(e:GetHandlerPlayer(),id)>0
end
function s.atktg(e,c)
    return c:GetFieldID()~=e:GetLabel()
end