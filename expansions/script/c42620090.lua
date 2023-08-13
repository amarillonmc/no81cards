--魔偶甜点冠后
local cm,m=GetID()

function cm.initial_effect(c)
    --th
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
    --send replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(cm.rtg)
    e3:SetOperation(cm.repop)
	e3:SetValue(cm.rval)
	c:RegisterEffect(e3)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)
end

function cm.contfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x71)
end

function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.contfilter,tp,0x04,0,1,nil)
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0x0c,0x0c,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,PLAYER_ALL,0x0c)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,tp,0x10)
end

function cm.opsfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x71) and (c:IsLevel(5) or c:IsRank(5))
end

function cm.opsfilter2(c)
    return c:IsSetCard(0x71) and c:IsType(0x6) and c:IsAbleToHand()
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0x0c,0x0c,1,1,nil)
    if #g>0 then
        Duel.HintSelection(g)
        if Duel.SendtoDeck(g,nil,2,REASON_EFFECT) and Duel.IsExistingMatchingCard(cm.opsfilter,tp,0x04,0,1,nil) and Duel.IsExistingMatchingCard(cm.opsfilter2,tp,0x10,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
            local rg=Duel.SelectMatchingCard(tp,cm.opsfilter2,tp,0x10,0,1,1,nil)
            if #rg>0 then
                Duel.SendtoHand(rg,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,rg)
            end
        end
    end
end

function cm.repfilter(c,tp)
    return c:IsControler(tp) and c:IsSetCard(0x71) and c:IsLocation(0x04) and c:IsFaceup() and (c:GetDestination()==0x01 or c:GetDestination()==0x02 or c:GetDestination()==0x10 or c:GetDestination(0x20) or c:GetDestination(0x40))
end

function cm.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return bit.band(r,REASON_EFFECT)~=0 and re:IsActivated() and eg:IsExists(cm.repfilter,1,nil,tp) and c:IsAbleToRemove() end
	if Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,1)) then
		return true
	else return false end
end

function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end

function cm.rval(e,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsSetCard(0x71) and c:IsLocation(0x04) and c:IsFaceup()
end

function cm.hcfilter(c)
	return c:IsFaceup() and c:IsCode(37164373)
end

function cm.handcon(e)
	return Duel.IsExistingMatchingCard(cm.hcfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end