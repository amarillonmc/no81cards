--千星流月
function c25000400.initial_effect(c)
	--special summon by effect
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c25000400.splimit)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25000400,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,25000400)
	e1:SetCost(c25000400.cost)
	e1:SetTarget(c25000400.target)
	e1:SetOperation(c25000400.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25000400,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,25000401)
	e2:SetCost(c25000400.spcost)
	e2:SetTarget(c25000400.sptg)
	e2:SetOperation(c25000400.spop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25000400,2))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_TODECK+CATEGORY_TOEXTRA)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c25000400.discon)
	e3:SetTarget(c25000400.distg)
	e3:SetOperation(c25000400.disop)
	c:RegisterEffect(e3)
end
function c25000400.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c25000400.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c25000400.filter(c)
	return c:IsCode(25000100) and c:IsAbleToHand()
end
function c25000400.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c25000400.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c25000400.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetFirstMatchingCard(c25000400.filter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c25000400.cfilter(c,tp)
	return not c:IsSummonableCard() and Duel.GetMZoneCount(tp,c)>0
end
function c25000400.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c25000400.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c25000400.cfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c25000400.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c25000400.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c25000400.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and (re:IsHasCategory(CATEGORY_SEARCH) or re:IsHasCategory(CATEGORY_DRAW)) and tp~=ep
end
function c25000400.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c25000400.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.DisableShuffleCheck()
		Duel.Destroy(eg,REASON_EFFECT,LOCATION_DECK)
		local tdg=Duel.GetOperatedGroup()
		local tdc=tdg:GetFirst()
		if tdc:IsLocation(LOCATION_EXTRA) then Duel.Remove(tdc,POS_FACEDOWN,0) end
		Duel.SendtoDeck(tdc,tp,2,REASON_EFFECT)
		if tdc:IsLocation(LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	end
end

