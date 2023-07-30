--制药术工具 研钵
local m=11631003
local cm=_G["c"..m]
--strings
cm.zhiyaoshu=true 
function cm.isYaojishi(card)  
	local code=card:GetCode()
	local ccode=_G["c"..code]
	return ccode.yaojishi
end
function cm.isZhiyaoshu(card)
	local code=card:GetCode()
	local ccode=_G["c"..code]
	return ccode.zhiyaoshu
end
function cm.isTezhiyao(card)
	local code=card:GetCode()
	local ccode=_G["c"..code]
	return ccode.tezhiyao
end



function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)  
	c:RegisterEffect(e1) 
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMINGS_CHECK_MONSTER)  
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	--search 2
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMINGS_CHECK_MONSTER)  
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.con2)
	e3:SetTarget(cm.tg2)
	e3:SetOperation(cm.op2)
	c:RegisterEffect(e3)
end

--search
function cm.cfilter(c)
	return cm.isYaojishi(c) and c:IsFaceup()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.filter(c)
	return cm.isTezhiyao(c) and c:IsAbleToHand()
end  
function cm.tgfilter(c,tp)
	return c:IsAbleToDeck() and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,c)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,0))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
	local g=Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)  
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			local tc=Duel.GetOperatedGroup():GetFirst()
			if tc and tc:IsLocation(LOCATION_HAND) then
				Duel.ShuffleHand(tp)
				local e1=Effect.CreateEffect(e:GetHandler())	
				e1:SetDescription(aux.Stringid(m,2))
				e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_PUBLIC)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
		end
	end
end

--search 2
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.GetTurnPlayer()==1-tp and not cm.con(e,tp,eg,ep,ev,re,r,rp) 
end
function cm.filter2(c)
	return cm.isYaojishi(c) and c:IsAbleToHand()
end
function cm.filter22(c)
	return cm.isYaojishi(c)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,1))
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local hand=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if hand:GetCount()<=0 then return end
	Duel.ConfirmCards(1-tp,hand)
	if (not hand:IsExists(cm.filter22,1,nil)) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
		local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
		end
	end
	Duel.ShuffleHand(tp)
end