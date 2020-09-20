--元素英雄 神·真新宇侠
function c9981606.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,89943723,aux.FilterBoolFunction(Card.IsFusionSetCard,0x1f,0x8),5,true,true)
	aux.AddContactFusionProcedure(c,c9981606.cfilter,LOCATION_ONFIELD+LOCATION_GRAVE,0,aux.tdcfop(c)):SetValue(1)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c9981606.splimit)
	c:RegisterEffect(e1)
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
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981606,2))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2)
	e2:SetCost(c9981606.cost)
	e2:SetOperation(c9981606.operation)
	c:RegisterEffect(e2)
	--atk/def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(c9981606.atkvalue)
	c:RegisterEffect(e4)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981606.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981606.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981606,0))
end 
c9981606.material_setcode=0x8
c9981606.neos_fusion=true
function c9981606.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c9981606.cfilter(c)
	return (c:IsFusionCode(89943723) or c:IsFusionSetCard(0x1f,0x8) and c:IsType(TYPE_MONSTER))
		and c:IsAbleToDeckOrExtraAsCost()
end
function c9981606.rmfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c9981606.atkvalue(e,c)
	return Duel.GetMatchingGroupCount(c9981606.rmfilter,c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,nil)*500
end
function c9981606.cfilter2(c)
	return c:IsSetCard(0x1f,0x8,0x9) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c9981606.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(9981606)==0
		and Duel.IsExistingMatchingCard(c9981606.cfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9981606.cfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetOriginalCode())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:GetHandler():RegisterFlagEffect(9981606,RESET_PHASE+PHASE_DAMAGE,0,1)
end
function c9981606.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=e:GetLabel()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981606,0))
end