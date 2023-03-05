--半英雄的思念体
function c115848157.initial_effect(c)
    --darklaw
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c115848157.darklawcon)
    e1:SetCost(c115848157.darklawcost)
    e1:SetTarget(c115848157.darklawtg)
    e1:SetOperation(c115848157.darklawop)
    c:RegisterEffect(e1)
    --draw
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1)
    e2:SetCondition(c115848157.drawcon)
    e2:SetTarget(c115848157.drawtg)
    e2:SetOperation(c115848157.drawop)
    c:RegisterEffect(e2)
    --to grave
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetOperation(c115848157.tgop)
    c:RegisterEffect(e3)
end

function c115848157.darklawcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0
end
function c115848157.darklawcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c115848157.darklawtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end
function c115848157.darklawop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
    e1:SetTargetRange(0xff, 0xff)
    e1:SetValue(LOCATION_REMOVED)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end

function c115848157.drawcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(115848157)~=0
end
function c115848157.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and e:GetHandler():IsAbleToRemove() end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c115848157.drawop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    if c:IsRelateToEffect(e) and Duel.Remove(c,FACE_UP,REASON_EFFECT)~=0 then
        Duel.Draw(p,d,REASON_EFFECT)
    end
end

function c115848157.tgop(e,tp,eg,ep,ev,re,r,rp)
    if bit.band(r,REASON_RETURN+REASON_ADJUST)~=0 then return end
    e:GetHandler():RegisterFlagEffect(115848157,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
