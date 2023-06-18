--现在是表演时间！ 莉莉米
local m=40011128
local cm=_G["c"..m]
cm.named_with_Ririmi=1
function cm.Tamayura(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Tamayura
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
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(0x200)
	e1:SetCountLimit(1,m)
    e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
    --negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,400111280)
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
    return cm.Rarami(c) and c:IsFaceup() and c:IsControler(tp) and c:IsType(TYPE_PENDULUM) and c:IsAbleToExtra()
end

function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetColumnGroup():IsExists(cm.contfilter,1,nil,tp)
end

function cm.tgtfilter(c)
    return c:IsAbleToHand() and cm.Tamayura(c) and c:IsType(0x1)
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local g=c:GetColumnGroup():Filter(cm.contfilter,nil,tp)
	if chk==0 then return c:IsAbleToExtra() and Duel.IsExistingMatchingCard(cm.tgtfilter,tp,0x01,0,1,nil) end
    g:AddCard(c)
    Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,2,nil,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
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
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            g=Duel.SelectMatchingCard(tp,cm.tgtfilter,tp,0x01,0,1,1,nil)
            if g:GetCount()>0 then
                Duel.SendtoHand(g,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,g)
            end
        end
    end
end

function cm.cfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and cm.Tamayura(c) and c:IsLocation(0x04) and c:IsFaceup()
end

function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not (rp==1-tp and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(cm.cfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end

function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
    Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,nil,nil)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end

function cm.negop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.SendtoExtraP(c,nil,REASON_EFFECT) then
	    Duel.NegateActivation(ev)
    end
end

function cm.consfilter(c)
    return cm.Tamayura(c) and c:IsFaceup()
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.consfilter,tp,0x04,0,1,nil)
end

function cm.tgsfilter(c)
    return cm.Rarami(c) and c:IsFaceup()
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