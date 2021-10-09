--平成三杰·盖亚SV
function c9981442.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c9981442.matfilter,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_EARTH),true)
--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
  --disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_GRAVE)
	e4:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e4)
  --remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9981442,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(c9981442.thcost)
	e3:SetTarget(c9981442.rmtg)
	e3:SetOperation(c9981442.rmop)
	c:RegisterEffect(e3)
   --atk/def down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c9981442.adcon)
	e2:SetTarget(c9981442.adtg)
	e2:SetValue(c9981442.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e3:SetValue(c9981442.defval)
	c:RegisterEffect(e3)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981442.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981442.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9981442,0))
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981442,3))
end
function c9981442.matfilter(c)
	return c:IsFusionSetCard(0x9bd1) and c:IsLevelAbove(5) and c:IsFusionType(TYPE_FUSION)
end
function c9981442.filter(c)
	return c:IsSetCard(0x9bd1) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9981442.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981442.rmfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9981442.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9981442.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c9981442.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981442,1))
end
function c9981442.adcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and e:GetHandler():GetBattleTarget()
end
function c9981442.adtg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end
function c9981442.atkval(e,c)
	return math.ceil(c:GetAttack()/10)
end
function c9981442.defval(e,c)
	return math.ceil(c:GetDefense()/10)
end