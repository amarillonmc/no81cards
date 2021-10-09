--强袭之龙骑士 盖亚
function c9952025.initial_effect(c)
	aux.AddCodeList(c,66889139)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xbd),c9952025.ffilter2,true)
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(66889139)
	c:RegisterEffect(e1)
--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9952025,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9952025.condition)
	e2:SetTarget(c9952025.target)
	e2:SetOperation(c9952025.operation)
	c:RegisterEffect(e2)
  --pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	e4:SetValue(DOUBLE_DAMAGE)
	c:RegisterEffect(e4)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9952025.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9952025.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9952025,0))
end
function c9952025.ffilter2(c)
	return c:IsLevelAbove(5) and c:IsRace(RACE_DRAGON)
end
function c9952025.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c9952025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAttackAbove(1300) and c:GetFlagEffect(9952025)==0 end
	c:RegisterFlagEffect(9952025,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c9952025.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsRelateToEffect(e) or c:GetAttack()<1300
		or Duel.GetCurrentChain()~=ev+1 or c:IsStatus(STATUS_BATTLE_DESTROYED) then
		return
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetValue(-1300)
	c:RegisterEffect(e1)
	if not c:IsHasEffect(EFFECT_REVERSE_UPDATE) then
		Duel.NegateActivation(ev)
	end
end
