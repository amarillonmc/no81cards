--魔偶甜点嗣女·珍珠帕法伊
local cm,m=GetID()

function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x71),3,2)
	c:EnableReviveLimit()
    --negate
	local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.discon)
	e3:SetTarget(cm.distg)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
    local e2=e3:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
    e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
end

function cm.discon(e,tp,eg,ep,ev,re,r,rp)
    return eg:GetSum(Card.GetAttack)>=2000
end

function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,0x04,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,0x06)
end

function cm.opdfilter(c)
    return c:IsAbleToDeck() and c:IsType(0x1)
end

function cm.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:RemoveOverlayCard(tp,1,1,REASON_EFFECT) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local g=Duel.SelectMatchingCard(1-tp,cm.opdfilter,tp,0,0x06,1,1,nil)
        if #g>0 then
            local tc=g:GetFirst()
            if tc:IsLocation(0x02) then
                Duel.ConfirmCards(tp,tc)
            else
                Duel.HintSelection(g)
            end
            if Duel.SendtoDeck(g,nil,2,REASON_EFFECT) then
                for nc in aux.Next(eg) do
                    local e1=Effect.CreateEffect(c)
                    e1:SetType(EFFECT_TYPE_FIELD)
                    e1:SetCode(EFFECT_DISABLE)
                    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
                    e1:SetTarget(cm.distg2)
                    e1:SetLabelObject(nc)
                    e1:SetReset(RESET_PHASE+PHASE_END)
                    Duel.RegisterEffect(e1,tp)
                    local e2=Effect.CreateEffect(c)
                    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
                    e2:SetCode(EVENT_CHAIN_SOLVING)
                    e2:SetCondition(cm.discon2)
                    e2:SetOperation(cm.disop2)
                    e2:SetLabelObject(nc)
                    e2:SetReset(RESET_PHASE+PHASE_END)
                    Duel.RegisterEffect(e2,tp)
                end
            end
        end
    end
end

function cm.distg2(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end

function cm.discon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end

function cm.disop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end

function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsSummonType(SUMMON_TYPE_XYZ) and c:IsPreviousLocation(LOCATION_MZONE)
end

function cm.tgtfilter(c,g)
    return (not g:IsExists(Card.IsCode,1,nil,c:GetCode())) and c:IsAbleToHand() and c:IsSetCard(0x71)
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgtfilter,tp,0x01,0,1,nil,Duel.GetMatchingGroup(Card.IsSetCard,tp,0x10,0,nil,0x71)) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.tgtfilter,tp,0x01,0,1,1,nil,Duel.GetMatchingGroup(Card.IsSetCard,tp,0x10,0,nil,0x71))
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end