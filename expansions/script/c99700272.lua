--龙界追猎者 阿特尼亚·元龙
function c99700272.initial_effect(c)
	c:SetSPSummonOnce(99700272)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.AND(aux.FilterBoolFunction(Card.IsFusionType,TYPE_SPELL+TYPE_TRAP),aux.FilterBoolFunction(Card.IsFusionSetCard,0xfd04)),aux.AND(aux.FilterBoolFunction(Card.IsFusionType,TYPE_MONSTER),aux.FilterBoolFunction(Card.IsFusionSetCard,0xfd02)),false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c99700272.splimit)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99700272,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c99700272.atkcon)
	e2:SetTarget(c99700272.atktg)
	e2:SetOperation(c99700272.atkop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--cannot be target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--Remove
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(99700272,1))
	e6:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,99700272)
	e6:SetTarget(c99700272.target)
	e6:SetOperation(c99700272.operation)
	c:RegisterEffect(e6)
end
function c99700272.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c99700272.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION 
end
function c99700272.atkfilter(c)
	return c:IsSetCard(0xfd04) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and (c:IsLocation(LOCATION_ONFIELD) or c:IsFaceup()) and c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)
end
function c99700272.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99700272.atkfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
end
function c99700272.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local atkval=Duel.GetMatchingGroupCount(c99700272.atkfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)*400
		local e=Effect.CreateEffect(c)
		e:SetType(EFFECT_TYPE_SINGLE)
		e:SetCode(EFFECT_UPDATE_ATTACK)
		e:SetValue(atkval)
		e:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e)
	end
end
function c99700272.filter(c)
	return c:IsSetCard(0xfd04) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c99700272.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99700272.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c99700272.thfilter(c)
	return (c:IsSetCard(0xfd02) or c:IsSetCard(0xfd04)) and c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c99700272.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local dg=Duel.SelectMatchingCard(tp,c99700272.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99700272.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end