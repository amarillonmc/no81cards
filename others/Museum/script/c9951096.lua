--假面驾驭·01·金属簇蝗虫
function c9951096.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x9bcd,0x3bc9),3,false)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c9951096.splimit)
	c:RegisterEffect(e1)
   --atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951096,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9951096)
	e2:SetTarget(c9951096.atktg)
	e2:SetOperation(c9951096.atkop)
	c:RegisterEffect(e2)
 --negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951096,3))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9951096.negcon)
	e2:SetTarget(c9951096.negtg)
	e2:SetOperation(c9951096.negop)
	c:RegisterEffect(e2)
 --cannot release
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_ONFIELD)
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e5)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951096.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951096.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951096,1))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9951096,0))
end
function c9951096.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c9951096.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
function c9951096.cfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_LINK+TYPE_XYZ)
end
function c9951096.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9951096.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9951096.atkfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c9951096.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9951096.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9951096.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9951096.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=g:GetSum(Card.GetLevel)
	local tc=Duel.GetFirstTarget()
	if ct>0 and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951096,1))
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9951096,2))
end
function c9951096.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c9951096.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c9951096.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951096,1))
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9951096,2))
end