--异闻带之王·阿周那
function c9951332.initial_effect(c)
	 --synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),aux.Tuner(nil),aux.Tuner(nil),aux.NonTuner(c9951332.sfilter),1,99)
	c:EnableReviveLimit()
 --immume
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c9951332.efilter)
	c:RegisterEffect(e4)
	--indes battle
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(c9951332.indes)
	c:RegisterEffect(e5)
--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9951332,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9951332.discon)
	e3:SetCost(c9951332.discost)
	e3:SetTarget(c9951332.distg)
	e3:SetOperation(c9951332.disop)
	c:RegisterEffect(e3)
 --cannot activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c9951332.aclimit)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9951332,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCondition(c9951332.rmcon)
	e4:SetCost(c9951332.rmcost)
	e4:SetTarget(c9951332.rmtg)
	e4:SetOperation(c9951332.rmop)
	c:RegisterEffect(e4)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951332.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951332.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951332,0))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9951332,1))
end
function c9951332.sfilter(c)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_SYNCHRO)
end
function c9951332.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c9951332.indes(e,c)
	return c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_EARTH+ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_WIND)
end
function c9951332.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler() and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c9951332.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9951332.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c9951332.disop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
  Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951332,0))
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9951332,2))
end
function c9951332.acfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c9951332.aclimit(e,re,tp)
	return Duel.IsExistingMatchingCard(c9951332.acfilter,e:GetHandlerPlayer(),LOCATION_REMOVED,LOCATION_REMOVED,1,nil,re:GetHandler():GetCode())
end
function c9951332.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c9951332.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9951332.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c9951332.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951332,0))
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9951332,3))
end
