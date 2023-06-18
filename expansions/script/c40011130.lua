--女士们先生们！ 菈菈米
local m=40011130
local cm=_G["c"..m]
cm.named_with_Rarami=1
function cm.Tamayura(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Tamayura
end
function cm.Ririmi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ririmi
end
function cm.FoxArt(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_FoxArt
end

function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
    --tohand
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(0x200)
	e1:SetCountLimit(1,m)
    e1:SetCondition(cm.thcon)
    e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
    --negate
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,400111300)
	e2:SetCondition(cm.negcon)
	e2:SetTarget(cm.negtg)
	e2:SetOperation(cm.negop)
	c:RegisterEffect(e2)
    --tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,m+1)
    e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end

function cm.contfilter(c,tp)
    return cm.Ririmi(c) and c:IsFaceup() and c:IsControler(tp) and c:IsType(TYPE_PENDULUM) and c:IsAbleToExtra()
end

function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetColumnGroup():IsExists(cm.contfilter,1,nil,tp)
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtra() end
    local g=c:GetColumnGroup():Filter(cm.contfilter,nil,tp)
    g:AddCard(c)
    Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,2,nil,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end

function Card.IsOwner(c,tp)
    return c:GetOwner()==tp
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=c:GetColumnGroup():Filter(cm.contfilter,nil,tp)
    if c:IsRelateToChain() and #g>0 then
        if #g>1 then
            g=g:Select(tp,1,1,nil)
        end
        g:AddCard(c)
        Duel.SendtoExtraP(g:Filter(Card.IsOwner,nil,tp),tp,REASON_EFFECT)
        Duel.SendtoExtraP(g:Filter(Card.IsOwner,nil,1-tp),1-tp,REASON_EFFECT)
        if g:FilterCount(Card.IsLocation,nil,0x40)==2 then
            local n=2
            if Duel.GetTurnPlayer()~=tp then n=3 end
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_FIELD)
            e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
            e2:SetTargetRange(LOCATION_HAND,0)
            e2:SetTarget(cm.tgcfilter)
            e2:SetReset(RESET_PHASE+PHASE_END,2)
            Duel.RegisterEffect(e2,tp)
            local e1=e2:Clone()
            e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
            Duel.RegisterEffect(e1,tp)
        end
    end
end

function cm.tgcfilter(e,c)
    return cm.FoxArt(c)
end

function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0x0c,0)==0
end

function cm.tgnfilter(c)
    return c:IsCode(40011126) and c:IsAbleToHand()
end

function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() and Duel.IsExistingMatchingCard(cm.tgnfilter,tp,0x01,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,nil,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end

function cm.negop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.SendtoExtraP(c,nil,REASON_EFFECT) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,cm.tgnfilter,tp,0x01,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
end

function cm.consfilter(c)
    return cm.Tamayura(c) and c:IsFaceup()
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.consfilter,tp,0x04,0,1,nil)
end

function cm.tgsfilter(c)
    return cm.Ririmi(c) and c:IsFaceup()
end

function cm.tgszfilter(g,tp)
    if #g==0 then return 0 end
    local zone=0
    for tc in aux.Next(g) do
        local loc,seq=tc:GetLocation(),tc:GetSequence()
        if loc==0x08 then
            if Duel.CheckLocation(tp,0x04,seq)==true then
                zone=zone|(1<<seq)
            end
        elseif seq>=5 and Duel.CheckLocation(tp,0x04,1 and seq==5 or 3)==true then
            zone=zone|(1<<(1 and seq==5 or 3))
        end
    end
    return zone
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local zone=cm.tgszfilter(Duel.GetMatchingGroup(cm.tgsfilter,tp,0x0c,0,nil),tp)
	if chk==0 then return zone~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,nil,nil)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c,zone=e:GetHandler(),cm.tgszfilter(Duel.GetMatchingGroup(cm.tgsfilter,tp,0x0c,0,nil),tp)
    if c:IsRelateToChain() and zone~=0 then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone)
    end
end