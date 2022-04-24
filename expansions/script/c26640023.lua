--晦暗交界的颜彩使者
local m=26640023
local cm=_G["c"..m]
function c26640023.initial_effect(c)
    local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,26640023)
	e1:SetCost(cm.discost)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,26640013)
	e2:SetTarget(cm.nthtg)
	e2:SetOperation(cm.nthop)
	c:RegisterEffect(e2)
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.tgfilter(c,tp)
	return c:IsFaceup() and (c:IsSetCard(0xe51) or c:IsSetCard(0xb81)) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function cm.thfilter(c,Code)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and(c:IsSetCard(0xe51) or c:IsSetCard(0xb81))and c:IsCode(Code)
end
function cm.hfilter(c,Code)
	return c:IsType(TYPE_MONSTER) 
		and(c:IsSetCard(0xe51) or c:IsSetCard(0xb81))
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.tgfilter(chkc,tp) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		if Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,tc:GetCode()) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode()) 
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			if  Duel.IsExistingMatchingCard(cm.hfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) 
			 then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			if  Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				local sg=Duel.SelectMatchingCard(tp,cm.hfilter,tp,LOCATION_HAND,0,1,1,nil)
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			else
				local sg=Duel.SelectMatchingCard(tp,cm.hfilter,tp,LOCATION_HAND,0,1,1,nil)
				Duel.Summon(tp,sg:GetFirst(),true,nil)
			end
		end
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(1,0)
        e1:SetTarget(cm.splimit)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
	end
	end
end
function cm.splimit(e,c)
	return not  (c:IsSetCard(0xe51) or c:IsSetCard(0xb81) ) 
end
---1效果
function cm.ntgfilter(c,tp)
	return c:IsFaceup() and (c:IsSetCard(0xe51) or c:IsSetCard(0xb81)) and Duel.IsExistingMatchingCard(cm.nthfilter,tp,LOCATION_REMOVED,0,1,nil,c:GetCode())
end
function cm.nthfilter(c,Code)
	return c:IsType(TYPE_MONSTER) 
		and (c:IsSetCard(0xe51) or c:IsSetCard(0xb81)) and  c:IsCode(Code)
end
function cm.nthtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and cm.ntgfilter(chkc,tp) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.ntgfilter,tp,LOCATION_REMOVED,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.ntgfilter,tp,LOCATION_REMOVED,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
end
function cm.nthop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)  then
        Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		if Duel.GetMatchingGroup(cm.nthfilter,tp,LOCATION_REMOVED,0,tc:GetCode()) then
            Duel.BreakEffect()
            local g=Duel.SelectMatchingCard(tp,cm.nthfilter,tp,LOCATION_REMOVED,0,1,1,nil,tc:GetCode())
			local sg=g:GetFirst()
            Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(1,0)
        e1:SetTarget(cm.slimit)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
    end
end
function cm.slimit(e,c)
	return not  (c:IsSetCard(0xe51) or c:IsSetCard(0xb81) ) and c:IsLocation(LOCATION_EXTRA)
end