--雷龙的雷庭
local m=21113205
local cm= _G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_GRAVE_SPSUMMON+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND)
	e3:SetCountLimit(1,m+2)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.con3)	
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
end
function cm.filter1(c)
	return c:IsSetCard(0x11c) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function cm.filter2(c)
	return c:IsSetCard(0x11c) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP+TYPE_SPELL) and not c:IsForbidden() and Duel.GetLocationCount(c:GetControler(),LOCATION_SZONE)>0
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_DECK,0,1,nil) and not Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil) then
		if Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g1=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_DECK,0,nil)
		local g=g1:Select(tp,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	elseif not Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil) then	
		if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local g2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_DECK,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=g2:Select(tp,1,1,nil)
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	elseif Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil) then	
		if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local g1=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_DECK,0,nil)
		local g2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_DECK,0,nil)
		local op=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))
		if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=g2:Select(tp,1,1,nil)
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=g1:Select(tp,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
		end
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return bit.band(loc,LOCATION_HAND)~=0 and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetOriginalRace()==RACE_THUNDER
end
function cm.q(c,e,tp)
	return c:IsSetCard(0x11c) and c:IsFaceup() and c:IsAbleToHand() and Duel.IsExistingMatchingCard(cm.w,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,c)
end
function cm.w(c,e,tp,sc)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(sc:GetCode()) and c:IsSetCard(0x11c)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(cm.q,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=Duel.SelectTarget(tp,cm.q,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) and Duel.IsExistingMatchingCard(cm.w,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,tc) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.w,e,tp,tc),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,tc)
		if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT+REASON_REDIRECT)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)>0 then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(cm.tdcon)
	e1:SetOperation(cm.tdop)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	end
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function cm.t(c)
	return c:IsAbleToHand() and c:IsSetCard(0x11c) and not c:IsFacedown()
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cm.t,tp,LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.t,tp,LOCATION_REMOVED,0,1,1,nil)
		if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end		
end