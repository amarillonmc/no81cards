--绝世女将·秦良玉
function c9950823.initial_effect(c)
	 --synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),aux.NonTuner(Card.IsSetCard,0xba5),1)
	c:EnableReviveLimit()
 --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950823,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9950823)
	e1:SetCondition(c9950823.spcon)
	e1:SetTarget(c9950823.sptg)
	e1:SetOperation(c9950823.spop)
	c:RegisterEffect(e1)
--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950823,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c9950823.condition)
	e1:SetCost(c9950823.cost)
	e1:SetOperation(c9950823.operation)
	c:RegisterEffect(e1)
 --disable
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9950823,0))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c9950823.discon)
	e4:SetTarget(c9950823.distg)
	e4:SetOperation(c9950823.disop)
	c:RegisterEffect(e4)
	--spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950823.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950823.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950823,1))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9950823,0))
end
function c9950823.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c9950823.spfilter(c,e,tp)
	return c:IsRace(RACE_WARRIOR) and c:IsSetCard(0xba5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9950823.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9950823.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9950823.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9950823.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9950823.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_DAMAGE and (c==Duel.GetAttacker() or c==Duel.GetAttackTarget())
		and not Duel.IsDamageCalculated()
end
function c9950823.cfilter(c)
	return (c:IsRace(RACE_WARRIOR) or c:IsSetCard(0xba5)) and c:IsAbleToRemoveAsCost()
end
function c9950823.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(9950823)==0
		and Duel.IsExistingMatchingCard(c9950823.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9950823.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetAttack())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:GetHandler():RegisterFlagEffect(9950823,RESET_PHASE+PHASE_DAMAGE,0,1)
end
function c9950823.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9950823,2))
end
function c9950823.discon(e,tp,eg,ep,ev,re,r,rp)
	local tgp,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainDisablable(ev)
		and tgp~=tp and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE
end
function c9950823.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c9950823.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or c:GetAttack()<1000 or not c:IsRelateToEffect(e) or Duel.GetCurrentChain()~=ev+1 or c:IsStatus(STATUS_BATTLE_DESTROYED) then
		return
	end
	Duel.NegateEffect(ev)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-1000)
	c:RegisterEffect(e1)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9950823,3))
end
