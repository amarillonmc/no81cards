--料理与颜彩的交界灵
local m=26640024
local cm=_G["c"..m]
function c26640024.initial_effect(c)
	aux.AddLinkProcedure(c,cm.cfilter,2,2)
	c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.thcon)
	e1:SetCost(cm.thcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
end
function cm.cfilter(c)
	return  (c:IsSetCard(0xe51) or c:IsSetCard(0xb81) ) and c:IsType(TYPE_MONSTER)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.thfilter(c)
	return c:IsCode(26640010) or c:IsCode(35800143)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    if e:GetHandler():GetMutualLinkedGroupCount()>0 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCHW+CATEGORY_DRAW)
		e:SetLabel(1)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetLabel(0)
	end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ShuffleDeck(tp)
		Duel.ConfirmCards(1-tp,g)
        if  e:GetLabel()==1 and Duel.IsPlayerCanDraw(tp,1)
		and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
            Duel.BreakEffect()
            Duel.Draw(tp,1,REASON_EFFECT)
        end
	end
end
-----1效果
function cm.desfilter(c,g)
	return g:IsContains(c)
		and Duel.IsExistingMatchingCard(cm.nthfilter,0,LOCATION_EXTRA,0,1,c)
end
function cm.nthfilter(c,g)
	return  (c:IsSetCard(0xe51) or c:IsSetCard(0xb81) ) and c:IsLinkBelow(3)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=e:GetHandler():GetLinkedGroup()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.desfilter(chkc,g) end
	if chk==0 then return Duel.IsExistingTarget(cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,g) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)  then
        Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
        Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        if Duel.GetLocationCountFromEx(tp)<=0 then return end
		if Duel.GetMatchingGroup(cm.nthfilter,tp,LOCATION_EXTRA,0,nil) and tc:IsType(TYPE_LINK) and tc:IsLocation(LOCATION_REMOVED) 
        and e:GetHandler():IsLocation(LOCATION_REMOVED) then
            Duel.BreakEffect()
            local g=Duel.SelectMatchingCard(tp,cm.nthfilter,tp,LOCATION_EXTRA,0,1,1,nil,tc)
            Duel.SpecialSummon(g,SUMMON_TYPE_LINK,tp,tp,true,false,POS_FACEUP)
            g:GetFirst():CompleteProcedure()
		end
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(1,0)
        e1:SetTarget(cm.splimit)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
	end
end
function cm.splimit(e,c)
	return not (c:IsSetCard(0xe51) or c:IsSetCard(0xb81) ) 
end