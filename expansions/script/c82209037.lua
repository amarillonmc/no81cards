local m=82209037
local cm=_G["c"..m]
--幻奏的音女 席福妮
function cm.initial_effect(c)
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE) 
	e1:SetCost(cm.spcost)  
	e1:SetTarget(cm.sptg)  
	e1:SetOperation(cm.spop)  
	c:RegisterEffect(e1) 
	--ret&draw  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1)  
	e2:SetCost(cm.tdcost)  
	e2:SetTarget(cm.tdtg)  
	e2:SetOperation(cm.tdop)  
	c:RegisterEffect(e2)   
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)  
end  
function cm.counterfilter(c)  
	return c:IsSetCard(0x9b)  
end  
function cm.spfilter(c)
	return c:IsSetCard(0x9b) and c:IsType(TYPE_MONSTER) --and c:IsDefenseBelow(1500) 
	and c:IsDiscardable()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,c) end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)   
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,c)
	e:SetLabel(g:GetFirst():GetOriginalCodeRule())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)  
	e1:SetTargetRange(1,0)  
	e1:SetTarget(cm.splimit)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp) 
end  
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)  
	return not c:IsSetCard(0x9b)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetCode(EFFECT_CANNOT_DISCARD_HAND)  
	e1:SetTargetRange(LOCATION_HAND,0)  
	e1:SetTarget(cm.costlimit)  
	e1:SetLabel(e:GetLabel())  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)  
end  
function cm.costlimit(e,c,re,r)
	return c:GetOriginalCodeRule()==e:GetLabel() and bit.band(r,0x80)==0x80 and re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsCode(82209037) 
end  
function cm.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 end  
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)  
	e1:SetTargetRange(1,0)  
	e1:SetTarget(cm.splimit)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp) 
end 
function cm.tdfilter(c)  
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9b) and c:IsAbleToDeck()  
end  
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.tdfilter(chkc) end  
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE,0,2,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE,0,2,2,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)  
end  
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)  
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)  
	if not tg or not (tg:FilterCount(Card.IsRelateToEffect,nil,e)>0) then return end  
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)  
	local g=Duel.GetOperatedGroup()  
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end  
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)  
	if ct>0 then  
		Duel.Draw(tp,1,REASON_EFFECT)  
	end  
end  