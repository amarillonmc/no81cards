--魔偶甜点卡卡·可可玛卡龙
local cm,m=GetID()

function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x71),2,3)
    --sp
	local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
    --Activate
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetRange(0x04)
    e1:SetCountLimit(1)
	e1:SetCondition(cm.descon)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
    --indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(0x04)
	e4:SetTargetRange(0x0c,0x08)
	e4:SetTarget(cm.tgifilter)
	e4:SetValue(aux.indoval)
	c:RegisterEffect(e4)
	--cannot be target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetRange(0x04)
	e5:SetTargetRange(0x0c,0x08)
	e5:SetTarget(cm.tgifilter)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

function cm.tgsfilter(g)
    return g:GetClassCount(Card.GetCode)==#g and g:FilterCount(Card.IsAbleToDeck,nil)==#g
end

function cm.tgsfilter2(c)
    return c:IsSetCard(0x71) and c:IsType(0x6) and c:IsAbleToHand()
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroup(tp,0x10,0):CheckSubGroup(cm.tgsfilter,2,2) and Duel.IsExistingMatchingCard(cm.tgsfilter2,tp,0x01,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,0x10)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.GetFieldGroup(tp,0x10,0):SelectSubGroup(tp,cm.tgsfilter,false,2,2)
    if #g>0 then
        Duel.HintSelection(g)
        if Duel.SendtoDeck(g,nil,2,REASON_EFFECT) then
            Duel.ShuffleDeck(tp)
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local sg=Duel.SelectMatchingCard(tp,cm.tgsfilter2,tp,0x01,0,1,1,nil)
            if #sg>0 then
                Duel.SendtoHand(sg,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,sg)
            end
        end
    end
end

function cm.condfilter(c,tp)
    return c:IsSetCard(0x71) and c:IsPreviousControler(tp) and c:IsPreviousLocation(0x10)
end

function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.condfilter,1,nil,tp)
end

function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function cm.immtg(c)
    return c:IsSetCard(0x71) and c:IsFaceup()
end

function cm.tgifilter2(c,tc)
    return c:GetColumnGroup():IsContains(tc)
end

function cm.immtg2(c,g)
    return g:IsExists(cm.tgifilter2,1,nil,c)
end

function cm.tgifilter(e,c)
    local g=Duel.GetMatchingGroup(cm.immtg,e:GetHandlerPlayer(),0x04,0,nil)
	return (g:IsContains(c) and c:IsFaceup()) or Duel.GetMatchingGroup(cm.immtg2,e:GetHandlerPlayer(),0x08,0x08,nil,g):IsContains(c)
end