--暴走之折纸使
function c9910014.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c9910014.ffilter,2,false)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_MZONE,0,Duel.Remove,POS_FACEUP,REASON_COST+REASON_FUSION+REASON_MATERIAL):SetValue(1)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c9910014.splimit)
	c:RegisterEffect(e1)
	--battle indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetCondition(c9910014.condtion)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9910014.condtion)
	e3:SetValue(c9910014.efilter)
	c:RegisterEffect(e3)
	--Negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9910014,0))
	e4:SetCategory(CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_QUICK_F)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c9910014.codisable)
	e4:SetTarget(c9910014.tgdisable)
	e4:SetOperation(c9910014.opdisable)
	c:RegisterEffect(e4)
end
function c9910014.ffilter(c)
	return c:IsFusionSetCard(0x950) and c:IsType(TYPE_MONSTER)
		and c:GetSummonLocation()==LOCATION_EXTRA
end
function c9910014.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
		or st&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION
end
function c9910014.mfilter(c)
	return not c:IsType(TYPE_PENDULUM)
end
function c9910014.condtion(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	return (c:GetSummonType()==SUMMON_TYPE_SPECIAL+1 or c:IsSummonType(SUMMON_TYPE_FUSION))
		and mg:GetCount()>0 and not mg:IsExists(c9910014.mfilter,1,nil)
end
function c9910014.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL)
end
function c9910014.codisable(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler()~=e:GetHandler()
		and e:GetHandler():GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x951)
end
function c9910014.tgdisable(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(9910014)==0 end
	c:RegisterFlagEffect(9910014,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
end
function c9910014.opdisable(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,1-tp,LOCATION_HAND,0,nil)
	if not c:IsFaceup() or not c:IsRelateToEffect(e) or g1:GetCount()==0 or g2:GetCount()==0
		or Duel.GetCurrentChain()~=ev+1 or c:IsStatus(STATUS_BATTLE_DESTROYED) then return
	end
	Duel.NegateActivation(ev)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	local sg2=g2:Select(1-tp,1,1,nil)
	sg1:Merge(sg2)
	Duel.HintSelection(sg1)
	Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)
end
