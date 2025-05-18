--千夜 屋檐的风景
function c60150603.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pendulum set/spsummon
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(60150603,3))
	e9:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_PZONE)
	e9:SetCountLimit(1)
	e9:SetTarget(c60150603.rptg)
	e9:SetOperation(c60150603.rpop)
	c:RegisterEffect(e9)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60150603,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,60150603)
	e2:SetCost(c60150603.spcost)
	e2:SetTarget(c60150603.sptg)
	e2:SetOperation(c60150603.spop)
	c:RegisterEffect(e2)
	local e22=e2:Clone()
	e22:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e22)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60150603,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_TO_DECK)
	e4:SetCountLimit(1,6010603)
	e4:SetCondition(c60150603.descon)
	e4:SetTarget(c60150603.destar)
	e4:SetOperation(c60150603.desop)
	c:RegisterEffect(e4)
	--Duel.AddCustomActivityCounter(60150603,ACTIVITY_SPSUMMON,c60150603.counterfilter)
end
function c60150603.counterfilter(c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c60150603.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(60150603,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c60150603.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c60150603.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_SPELLCASTER)
end
function c60150603.rpfilter(c,e,tp)
	return c:IsSetCard(0x3b21) and c:IsAbleToDeck() and c:IsFaceup()
end
function c60150603.rptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c60150603.rpfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60150603.rpop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c60150603.rpfilter,p,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if g:GetCount()>=1 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=g:Select(p,1,3,nil)
		Duel.ConfirmCards(1-p,sg)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.ShuffleDeck(p)
		Duel.BreakEffect()
		Duel.Draw(p,1,REASON_EFFECT)
	end
end
function c60150603.xyzlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x5b21)
end
function c60150603.cfilter(c)
	return c:IsSetCard(0x3b21) and c:IsType(TYPE_MONSTER) and c:IsFaceup() 
		and c:IsAbleToDeckAsCost()
end
function c60150603.afilter(c)
	return c:IsSetCard(0x3b21) and c:IsAbleToHand()
end
function c60150603.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150603.cfilter,tp,LOCATION_EXTRA,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c60150603.cfilter,tp,LOCATION_EXTRA,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c60150603.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150603.afilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c60150603.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60150603.afilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c60150603.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_EXTRA) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c60150603.destar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60150603.desop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c60150603.filter(c,e,tp)
	return c:IsSetCard(0x3b21) and not c:IsCode(60150603) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60150603.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c60150603.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c60150603.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60150603.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c60150603.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end
