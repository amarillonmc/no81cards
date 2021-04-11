--完全束缚
function c60159942.initial_effect(c)
	c:SetUniqueOnField(1,0,60159942)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_POSITION)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(c60159942.negcon)
    e2:SetOperation(c60159942.negop)
    c:RegisterEffect(e2)
end
function c60159942.negcon(e,tp,eg,ep,ev,re,r,rp)
    local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    return bit.band(loc,LOCATION_ONFIELD)~=0
end
function c60159942.negop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=re:GetHandler()
    if re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and rc:IsRelateToEffect(re) and rc:IsCanTurnSet() and not re:IsActiveType(TYPE_PENDULUM) then
        rc:CancelToGrave()
        Duel.ChangePosition(rc,POS_FACEDOWN)
        Duel.RaiseEvent(rc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetDescription(aux.Stringid(60159942,1))
        e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_TRIGGER)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        rc:RegisterEffect(e1)
	elseif re:IsActiveType(TYPE_MONSTER) and rc:IsRelateToEffect(re) and rc:IsCanTurnSet() then
		Duel.ChangePosition(rc,POS_FACEDOWN_DEFENSE)
		local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetDescription(aux.Stringid(60159942,0))
        e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        rc:RegisterEffect(e1)
    end
end
