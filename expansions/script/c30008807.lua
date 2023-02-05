--空隙机 出动
local m=30008807
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.tdtg)
	e1:SetOperation(cm.tdop)
	c:RegisterEffect(e1)
	aux.RegisterMergedDelayedEvent(c,m,EVENT_REMOVE)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--Effect 3  
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e12:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e12:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e12:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e12:SetCountLimit(1)
	e12:SetTarget(cm.thtg)
	e12:SetOperation(cm.thop)
	c:RegisterEffect(e12)  
end
--to deck
function cm.cfilter(c,e)
	return  c:IsAbleToGrave() and c:IsCanBeEffectTarget(e) and c:IsLocation(LOCATION_REMOVED)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) end
	if chk==0 then return eg:IsExists(cm.cfilter,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=eg:FilterSelect(tp,cm.cfilter,1,1,nil,e)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)>0 then
		Duel.Recover(tp,500,REASON_EFFECT)
	end
end
--special summon
function cm.ckf(c)
	return  not c:IsType(TYPE_TOKEN)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and eg:IsExists(cm.ckf,1,nil)
end
function cm.spfilter(c,e,tp)
	if c:IsLocation(LOCATION_REMOVED) and c:IsFacedown() then return false end
	return c:GetBaseDefense()==3333 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,m+100)==0
		and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.RegisterFlagEffect(tp,m+100,RESET_CHAIN,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,r,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
end
--Effect 3 
function cm.tdfilter(c)
	local b1=c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)
	return c:GetBaseDefense()==3333 and b1 and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and cm.tdfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c) and c:IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,c)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if e:GetActivateLocation()==LOCATION_GRAVE and c:IsHasEffect(EFFECT_NECRO_VALLEY) then return end
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then	  
		local g=Group.FromCards(c,tc)
		if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 or g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)==0 then return false end
		Duel.BreakEffect()
		Duel.Draw(e:GetHandlerPlayer(),1,REASON_EFFECT)
	end
end 