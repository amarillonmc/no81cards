--燃烧祭祀 玉响
local m=40011136
local cm=_G["c"..m]
cm.named_with_Tamayura=1
function cm.Tamayura(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Tamayura
end
function cm.Ririmi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ririmi
end
function cm.Rarami(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Rarami
end

function cm.initial_effect(c)
    --xyz summon
	aux.AddXyzProcedure(c,nil,3,2)
	c:EnableReviveLimit()
    --
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(0x04)
	e1:SetCountLimit(1,m)
    e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
    --destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,m+1)
	e2:SetTarget(cm.reptg)
	e2:SetValue(cm.repval)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2)
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end

function cm.tgtfilter(c)
    return (cm.Ririmi(c) or cm.Rarami(c)) and c:IsType(TYPE_PENDULUM) and (c:IsFaceup() or c:IsLocation(0x01)) and (c:IsAbleToHand() or (Duel.GetLocationCount(tp,0x08,2,0x1,0x11)>0 and not c:IsForbidden()))
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.tgtfilter,tp,0x41,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0x41,tp,1)
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
    local tc=Duel.SelectMatchingCard(tp,cm.tgtfilter,tp,0x41,0,1,1,nil):GetFirst()
    if tc then
        local b1=tc:IsAbleToHand()
        local b2=Duel.GetLocationCount(tp,0x08,2,0x1,0x11)>0 and not tc:IsForbidden()
        if b1 and (not b2 or Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))==0) then
            Duel.SendtoHand(tc,nil,REASON_EFFECT)
        else
            Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
        end
    end
end

function cm.repfilter(c,tp)
	return c:IsFaceup() and cm.Tamayura(c) and c:IsLocation(0x04) and c:IsControler(tp) and (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT))) and not c:IsReason(REASON_REPLACE)
end

function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(cm.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end

function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end

function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end