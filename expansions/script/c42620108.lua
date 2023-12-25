--魔偶甜点使·熔岩巧克力德古拉
local cm,m=GetID()

function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_EARTH),4,2)
	c:EnableReviveLimit()
    --lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(cm.lvtg)
	e1:SetValue(cm.lvval)
	c:RegisterEffect(e1)
    --tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(0x04)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1,m)
	e2:SetCost(cm.thcost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
    --sp
	local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetRange(0x04)
    e3:SetCountLimit(1,m+1)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end

function cm.lvtg(e,c)
	return c:IsLevelAbove(1) and c:IsType(0x1) and c:IsSetCard(0x71)
end

function cm.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return 4
	else return lv end
end

function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
    c:RemoveOverlayCard(tp,1,1,REASON_COST)
end

function cm.tgdfilter(c)
    return c:IsFaceup() and c:IsAbleToHand()
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(cm.tgdfilter,tp,0x04,0x04,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectTarget(tp,cm.tgdfilter,tp,0x04,0x04,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,nil,nil)
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToChain() then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end

function cm.consfilter(c,tp)
    return c:IsSetCard(0x71) and c:IsControler(tp)
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.consfilter,1,nil,tp)
end

function cm.tgsfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x71)
end

function cm.tgsfilter2(c,e,tp,g)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x71) and (not g:IsExists(Card.IsRace,1,nil,c:GetRace()))
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x03)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,0x04)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,cm.tgsfilter2,tp,0x03,0,1,1,nil,e,tp,Duel.GetMatchingGroup(cm.tgsfilter,tp,0x04,0,nil))
        if #g>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
    local c=e:GetHandler()
    if c:IsRelateToChain() and c:IsFaceup() then
        local e0=Effect.CreateEffect(c)
        e0:SetType(EFFECT_TYPE_SINGLE)
        e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
        e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e0:SetValue(1)
        c:RegisterEffect(e0)
    end
end