--九尾妖狐 玉响
local m=40011132
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
	--pendulum summon
	aux.EnablePendulumAttribute(c)
    --tohand
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(0x200)
	e1:SetCountLimit(1,m)
    e1:SetCondition(cm.thcon)
    e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
    --negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,400111320)
	e2:SetTarget(cm.negtg)
	e2:SetOperation(cm.negop)
	c:RegisterEffect(e2)
    local e4=e2:Clone()
    e4:SetCode(EVENT_SUMMON_SUCCESS)
    c:RegisterEffect(e4)
    --tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(0x04)
	e3:SetCountLimit(1,m+1)
    e3:SetCost(cm.spcost)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end

function cm.contfilter(c)
    return cm.Ririmi(c) or cm.Rarami(c)
end

function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.contfilter,tp,0x200,0,1,e:GetHandler())
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,0x04)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,nil,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,Duel.GetMatchingGroup(aux.TRUE,tp,0x200,0,c):GetFirst(),1,nil,nil)
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToChain() and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
        local g=Duel.GetFieldGroup(tp,0x200,0)
        if #g>0 then
            Duel.Destroy(g,REASON_EFFECT)
        end
    end
end

function cm.tgnfilter(c)
    return cm.contfilter(c) and c:IsAbleToHand() and c:IsType(TYPE_PENDULUM) and (c:IsFaceup() or c:IsLocation(0x01))
end

function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgnfilter,tp,0x41,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x41)
end

function cm.negop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.tgnfilter,tp,0x41,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

function cm.costsfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToGraveAsCost()
end

function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.costsfilter,tp,0x40,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,cm.costsfilter,tp,0x40,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_EFFECT)
end

function cm.tgsfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(m) and cm.Tamayura(c)
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgsfilter,tp,0x01,0,1,nil,e,tp) and Duel.GetLocationCount(tp,0x04)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x01)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.tgsfilter,tp,0x01,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end