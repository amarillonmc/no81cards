--光之国·X-艾雷王装甲
function c9950382.initial_effect(c)
	   --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x9bd1),4,3,c9950382.ovfilter,aux.Stringid(9950382,2))
	c:EnableReviveLimit()
--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9950382.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c9950382.defval)
	c:RegisterEffect(e2)
  --negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950382,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c9950382.discon)
	e1:SetCost(c9950382.cost)
	e1:SetTarget(c9950382.distg)
	e1:SetOperation(c9950382.disop)
	c:RegisterEffect(e1)
 --
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950382,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(TIMING_END_PHASE)
	e3:SetCountLimit(1)
	e3:SetCondition(c9950382.spcon)
	e3:SetTarget(c9950382.sptg)
	e3:SetOperation(c9950382.spop)
	c:RegisterEffect(e3)
  --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950382.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950382.ovfilter(c)
	return c:IsFaceup() and c:IsCode(9950374) 
end
function c9950382.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950382,0))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9950382,1))
end
function c9950382.atkfilter(c)
	return c:IsSetCard(0x9bd1) and c:IsType(TYPE_XYZ) and c:GetAttack()>=0
end
function c9950382.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c9950382.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c9950382.deffilter(c)
	return c:IsSetCard(0x9bd1) and c:IsType(TYPE_XYZ) and c:GetDefense()>=0
end
function c9950382.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c9950382.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c9950382.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c9950382.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9950382.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c9950382.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950382,0))
end
function c9950382.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(9950382)~=0 and Duel.GetCurrentPhase()==PHASE_END
end
function c9950382.spfilter(c,e,tp)
	return c:IsCode(9950374) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9950382.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c9950382.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9950382.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9950382.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9950382.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
