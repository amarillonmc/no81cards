--shiny library
function c28399999.initial_effect(c)
	aux.AddCodeList(c,28399999)
	c:SetUniqueOnField(1,0,28399999)
	c:SetSPSummonOnce(28399999)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetDescription(aux.Stringid(28399999,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,28399999+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c28399999.descon)
	e1:SetCost(c28399999.descost)
	e1:SetTarget(c28399999.destg)
	e1:SetOperation(c28399999.desop)
	c:RegisterEffect(e1)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c28399999.rmtg)
	e3:SetOperation(c28399999.rmop)
	c:RegisterEffect(e3)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCost(c28399999.tgcost)
	e4:SetTarget(c28399999.tgtg)
	e4:SetOperation(c28399999.tgop)
	c:RegisterEffect(e4)
	--to deck
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e6:SetTarget(c28399999.tdtg)
	e6:SetOperation(c28399999.tdop)
	c:RegisterEffect(e6)
	--draw
	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_DRAW)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	e9:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e9:SetCountLimit(1,28399999)
	e9:SetTarget(c28399999.drtg)
	e9:SetOperation(c28399999.drop)
	c:RegisterEffect(e9)
	--search
	local e10=Effect.CreateEffect(c)
	e10:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e10:SetType(EFFECT_TYPE_ACTIVATE)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetTarget(c28399999.thtg)
	e10:SetOperation(c28399999.thop)
	c:RegisterEffect(e10)
	--attack up-self
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_SINGLE)
	e14:SetCode(EFFECT_UPDATE_ATTACK)
	e14:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e14:SetRange(LOCATION_MZONE)
	e14:SetValue(500)
	c:RegisterEffect(e14)
	--attack up-other
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_FIELD)
	e14:SetCode(EFFECT_UPDATE_ATTACK)
	e14:SetRange(LOCATION_MZONE)
	e14:SetTargetRange(LOCATION_MZONE,0)
	e14:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_FAIRY))
	e14:SetValue(500)
	c:RegisterEffect(e14)
	--attack up-activated
	local e14=Effect.CreateEffect(c)
	e14:SetCategory(CATEGORY_ATKCHANGE)
	e14:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e14:SetCode(EVENT_SPSUMMON_SUCCESS)
	e14:SetProperty(EFFECT_FLAG_DELAY)
	e14:SetRange(LOCATION_MZONE)
	e14:SetCondition(c28399999.atkcon)
	e14:SetTarget(c28399999.atktg)
	e14:SetOperation(c28399999.atkop)
	c:RegisterEffect(e14)
	--spsummon-self
	local e19=Effect.CreateEffect(c)
	e19:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e19:SetType(EFFECT_TYPE_IGNITION)
	e19:SetRange(LOCATION_HAND)
	e19:SetTarget(c28399999.sptg)
	e19:SetOperation(c28399999.spop)
	c:RegisterEffect(e19)
	--spsummon-other
	local e19=Effect.CreateEffect(c)
	e19:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_GRAVE_ACTION)
	e19:SetType(EFFECT_TYPE_ACTIVATE)
	e19:SetCode(EVENT_FREE_CHAIN)
	e19:SetTarget(c28399999.sptg)
	e19:SetOperation(c28399999.spop)
	c:RegisterEffect(e19)
	--damage
	local e23=Effect.CreateEffect(c)
	e23:SetCategory(CATEGORY_DAMAGE)
	e23:SetType(EFFECT_TYPE_IGNITION)
	--e23:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e23:SetRange(LOCATION_MZONE)
	e23:SetTarget(c28399999.damtg)
	e23:SetOperation(c28399999.damop)
	c:RegisterEffect(e23)
	--recover
	local e24=Effect.CreateEffect(c)
	e24:SetCategory(CATEGORY_RECOVER)
	e24:SetType(EFFECT_TYPE_IGNITION)
	--e24:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e24:SetRange(LOCATION_MZONE)
	e24:SetTarget(c28399999.rectg)
	e24:SetOperation(c28399999.recop)
	c:RegisterEffect(e24)
	--disable
	local e32=Effect.CreateEffect(c)
	e32:SetCategory(CATEGORY_DISABLE)
	e32:SetType(EFFECT_TYPE_QUICK_O)
	e32:SetCode(EVENT_CHAINING)
	e32:SetRange(LOCATION_MZONE)
	e32:SetCondition(c28399999.discon)
	e32:SetCost(c28399999.discost)
	e32:SetTarget(c28399999.distg)
	e32:SetOperation(c28399999.disop)
	c:RegisterEffect(e32)
end
--destroy
function c28399999.descon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2--Duel.IsMainPhase()
end
function c28399999.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c28399999.desfilter(c)
	return c:IsFaceup()
end
function c28399999.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chck:IsControler(1-tp) and c28399999.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c28399999.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c28399999.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c28399999.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
--remove
function c28399999.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c28399999.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc then
		Duel.HintSelection(Group.FromCards(tc))
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
--to grave
function c28399999.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c28399999.tgfilter(c)
	return c:IsSetCard(0x283) and c:IsAbleToGrave()
end
function c28399999.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28399999.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c28399999.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c28399999.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
--to deck
function c28399999.tdfilter(c)
	return c:IsSetCard(0x283) and c:IsFaceupEx() and c:IsAbleToDeck()
end
function c28399999.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c28399999.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c28399999.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c28399999.tdfilter,tp,LOCATION_GRAVE,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c28399999.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
--draw
function c28399999.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c28399999.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)--Duel.Draw(tp,1,REASON_EFFECT)
end
--search
function c28399999.thfilter(c,chk)
	return c:IsSetCard(0x283) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and (chk==0 or aux.NecroValleyFilter()(c))
end
function c28399999.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28399999.thfilter,tp,LOCATION_DECK,0,1,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28399999.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c28399999.thfilter,tp,LOCATION_DECK,0,1,1,nil,1):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
--attack up-activated
function c28399999.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c28399999.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
end
function c28399999.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetValue(500)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end
--spsummon-self
function c28399999.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c28399999.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--spsummon-other
function c28399999.spfilter(c,e,tp,chk)
	return c:IsSetCard(0x283) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (chk==0 or aux.NecroValleyFilter()(c))-- and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c28399999.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c28399999.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c28399999.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c28399999.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,1):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
--damage
function c28399999.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c28399999.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
--recover
function c28399999.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c28399999.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)--Duel.Recover(tp,1000,REASON_EFFECT)
end
--disable
function c28399999.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsChainDisablable(ev) and re:IsActiveType(TYPE_MONSTER)
end
function c28399999.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c28399999.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c28399999.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
