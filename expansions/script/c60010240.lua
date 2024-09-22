--流萤-盈茧炽盛-
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	aux.AddCodeList(c,60010029)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(cm.pspcon)
	e2:SetOperation(cm.pspop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(cm.spcon)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
end
function cm.pspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,c)
	local num=g:GetCount()
	if Duel.IsPlayerAffectedByEffect(tp,60010129) and num>0 then num=1 end
	return num>0 and g:FilterCount(Card.IsAbleToGraveAsCost,nil)>=num and Duel.IsPlayerCanDiscardDeck(tp,num)
end
function cm.pspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,c)
	if Duel.IsPlayerAffectedByEffect(tp,60010129) then
		local ct=g:GetCount()
		if ct>Duel.GetFieldGroupCount(tp,LOCATION_DECK,0) then ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=g:Select(tp,1,ct,nil)
	end
	Duel.SendtoGrave(g,REASON_COST)
	Duel.DiscardDeck(tp,#g,REASON_COST)
end
function cm.thfilter(c)
	return c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		--spsummon limit
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
		e1:SetCondition(cm.slcon)
		e1:SetOperation(cm.slop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.slfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsFaceup()
end
function cm.slcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.slfilter,1,nil,tp)
end
function cm.slop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.slfilter,nil,tp)
	for c in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetLabel(c:GetRace())
		e1:SetTarget(cm.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.splimit(e,c)
	return c:IsRace(e:GetLabel())
end

function cm.filter(c,tp,rp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and (c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT)))
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,tp,rp) and Duel.IsEnvironment(60010029,tp)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then
	Duel.SetChainLimit(function(e,ep,tp)
	return tp==ep
end)end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,0,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
