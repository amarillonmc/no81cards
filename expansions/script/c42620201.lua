--邪恶★双子露娜病毒
local cm,m=GetID()

function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
    --
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,1)
    e3:SetCondition(cm.damcon)
	e3:SetValue(cm.damval)
	c:RegisterEffect(e3)
    --negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
    e2:SetRange(0x08)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.discon)
    e2:SetCost(cm.discost)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
end

function cm.condfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x2151)
end

function cm.damcon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.IsExistingMatchingCard(cm.condfilter,tp,0x04,0,1,nil) and not Duel.IsExistingMatchingCard(cm.condfilter,tp,0,0x04,1,nil)
end

function cm.damval(e,re,val,r,rp,rc)
    if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
        return val*2
    end
	return val
end

function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.condfilter,tp,0x04,0,1,nil) and re:IsActiveType(0x6) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end

function cm.costdffilter(c,tc)
    return c:GetAttribute()==tc:GetAttribute()
end

function cm.costdfilter(c,g)
    return c:IsAbleToGrave() and c:IsSetCard(0x1151) and g:IsExists(cm.costdffilter,1,nil,c)
end

function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(cm.condfilter,tp,0x04,0,nil)
    if chk==0 then return Duel.CheckLPCost(tp,1100) and Duel.IsExistingMatchingCard(cm.costdfilter,tp,0x03,0,1,nil,g) end
	Duel.PayLPCost(tp,1100)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,cm.costdfilter,tp,0x03,0,1,1,nil,g)
    Duel.SendtoGrave(sg,REASON_COST)
end

function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end

function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end