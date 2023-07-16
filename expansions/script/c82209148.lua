--神言之堕天使
local m=82209148
local cm=c82209148
function cm.initial_effect(c)
	--tohand  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e1:SetCode(EVENT_BATTLE_DESTROYING)  
	e1:SetOperation(cm.regop)  
	c:RegisterEffect(e1)  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_SEARCH)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,m)  
	e2:SetCondition(cm.thcon)  
	e2:SetTarget(cm.thtg)  
	e2:SetOperation(cm.thop)  
	c:RegisterEffect(e2) 
	--todeck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1)) 
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m+10000)
	e3:SetCondition(cm.tdcon1)
	e3:SetTarget(cm.tdtg)
	e3:SetOperation(cm.tdop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN) 
	e4:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e4:SetCondition(cm.tdcon2)
	c:RegisterEffect(e4)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)  
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)  
end  
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():GetFlagEffect(m)>0 and Duel.GetCurrentPhase()==PHASE_MAIN2  
end  
function cm.filter(c)  
	return c:IsSetCard(0xef) and c:IsAbleToHand()  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end
function cm.tdfilter1(c)
	return c:IsSetCard(0xef) and c:IsLevelAbove(5) and c:IsFaceup()
end
function cm.tdcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.tdfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function cm.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.tdfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function cm.tdfilter2(c,e)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)   
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.tdfilter2(chkc,e) end
	local g0=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_MZONE,nil) 
	if chk==0 then return cm.tdfilter2(c,e) and Duel.IsExistingTarget(cm.tdfilter2,tp,LOCATION_GRAVE,0,1,c,e) and g0:GetCount()>0 end
	local g=Duel.SelectMatchingCard(tp,cm.tdfilter2,tp,LOCATION_GRAVE,0,1,1,c,e)
	g:AddCard(c)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g0,1,0,0)  
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)  
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=2 then return end  
	Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()  
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end  
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)  
	if ct==2 then  
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,1,nil)
		if sg:GetCount()>0 then
			Duel.HintSelection(sg)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end
	end  
end