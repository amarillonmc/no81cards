--魔偶甜点糖果屋
local cm,m=GetID()

function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.actg)
	e1:SetOperation(cm.acop)
	c:RegisterEffect(e1)
	--immune effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x71))
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
	--to deck and draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.tddtg)
	e3:SetOperation(cm.tddop)
	c:RegisterEffect(e3)
end

function cm.tgafilter(c)
	return c:IsSetCard(0x71) and c:IsAbleToHand() and c:IsType(0x1) and c:IsLevelAbove(1)
end

function cm.actg(e,tp,eg,ep,ev,re,r,rp,chk)
    local rg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0x10,0,nil)
    local dg=Duel.GetMatchingGroup(cm.tgafilter,tp,0x01,0,nil)
    local lg,minl=dg:GetMinGroup(Card.GetLevel)
	if chk==0 then return rg and #dg>0 and lg and #rg>=minl end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,minl,tp,0x10)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
	c:RegisterFlagEffect(m,RESET_PHASE+PHASE_END,0,1)
	c:GetFlagEffect(m)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	Duel.GetFlagEffect(tp,m)
end

function cm.opafilter(c,n)
    return cm.tgafilter(c) and c:IsLevelBelow(n)
end

function cm.acop(e,tp,eg,ep,ev,re,r,rp)
    local rg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0x10,0,nil)
    local dg=Duel.GetMatchingGroup(cm.tgafilter,tp,0x01,0,nil)
    local lg,minl=dg:GetMinGroup(Card.GetLevel)
    if rg and dg and #rg>=minl then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        rg=rg:Select(tp,minl,#rg,nil)
        Duel.HintSelection(rg)
        local n=Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
        if n>0 then
            if rg:IsExists(Card.IsLocation,1,nil,0x01) then
                Duel.ShuffleDeck(tp)
            end
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local sg=Duel.SelectMatchingCard(tp,cm.opafilter,tp,0x01,0,1,1,nil,n)
            if #sg>0 then
                Duel.SendtoHand(sg,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,sg)
            end
        end
    end
end

function cm.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer() and re:IsActiveType(TYPE_MONSTER)
end

function cm.tdfilter(c)
	return c:IsAbleToDeck() and c:IsSetCard(0x71) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end

function cm.tddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(cm.tdfilter,tp,0x04,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	local tc=Duel.SelectTarget(tp,cm.tdfilter,tp,0x04,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,1)
end

function cm.tddop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) then
	    Duel.Draw(tp,1,REASON_EFFECT)
	end
end