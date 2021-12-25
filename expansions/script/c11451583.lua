--樱落回响诗笺
--21.06.23
local m=11451583
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(0,EFFECT_FLAG2_COF)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCondition(cm.condition2)
	e2:SetCost(cm.cost)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetLabelObject(e2)
	e3:SetTargetRange(1,0)
	e3:SetTarget(cm.actarget)
	e3:SetOperation(cm.costop)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetTarget(cm.drtg)
	e4:SetOperation(cm.drop)
	c:RegisterEffect(e4)
end
function cm.actarget(e,te,tp)
	return te:GetHandler()==e:GetHandler() and te==e:GetLabelObject()
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	c:CancelToGrave(false)
	te:SetType(EFFECT_TYPE_ACTIVATE)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetLabelObject(te)
	e1:SetCondition(cm.rscon)
	e1:SetOperation(cm.rsop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function cm.rscon(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	re:SetType(EFFECT_TYPE_QUICK_O)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END and Duel.GetCurrentChain()==0
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END and Duel.GetCurrentChain()==0 and Duel.GetTurnPlayer()==1-tp
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckActivateEffect(false,false,false)~=nil and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function cm.filter(c)
	return c:GetTurnID()==Duel.GetTurnCount() and not c:IsReason(REASON_RETURN) and c:IsType(TYPE_MONSTER)
end
function cm.spfilter(c,e,tp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	return c:IsSetCard(0x97f) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and #g>=c:GetRank() and g:IsExists(Card.IsCanOverlay,1,nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():SetStatus(STATUS_EFFECT_ENABLED,true)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local mg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local tg=mg:FilterSelect(tp,Card.IsCanOverlay,1,3,nil)
		if #tg>0 then Duel.Overlay(tc,tg) end
	end
end
function cm.tdfilter(c)
	return c:IsSetCard(0x9f38) and c:IsType(TYPE_XYZ) and c:IsAbleToDeck()
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and c:IsAbleToDeck() and Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE,0,1,99,nil)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #tg<=0 or not c:IsRelateToEffect(e) then return end
	tg:AddCard(c)
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then Duel.Draw(tp,1,REASON_EFFECT) end
end