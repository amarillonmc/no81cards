--苍死神
function c9950031.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x3ba1),aux.FilterBoolFunction(Card.IsFusionSetCard,0xba1),3,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c9950031.condition)
	e1:SetCost(c9950031.cost)
	e1:SetTarget(c9950031.target)
	e1:SetOperation(c9950031.activate)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c9950031.atkval)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c9950031.efilter)
	c:RegisterEffect(e1)
	 --negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c9950031.distg)
	c:RegisterEffect(e2)
	--chain attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950031,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetCondition(c9950031.atcon)
	e2:SetCost(c9950031.atcost)
	e2:SetOperation(c9950031.atop)
	c:RegisterEffect(e2)
	--pendulum
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(9950031,0))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(c9950031.pencon)
	e6:SetTarget(c9950031.pentg)
	e6:SetOperation(c9950031.penop)
	c:RegisterEffect(e6)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950031.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950031.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950031,1))
end
function c9950031.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c9950031.distg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end
function c9950031.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c9950031.cfilter(c)
	return c:IsSetCard(0xba1) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c9950031.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.IsPlayerAffectedByEffect(tp,EFFECT_DISCARD_COST_CHANGE) then return true end
	if chk==0 then return Duel.IsExistingMatchingCard(c9950031.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c9950031.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c9950031.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
end
function c9950031.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetValue(c9950031.aclimit)
	e1:SetLabel(tc:GetCode())
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetLabel(tc:GetFieldID())
	Duel.RegisterEffect(e2,tp)
	e1:SetLabelObject(e2)
end
function c9950031.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsCode(e:GetLabel()) and (not rc:IsOnField() or rc:GetFieldID()~=e:GetLabelObject():GetLabel())
end
function c9950031.atkfilter(c)
	return c:IsSetCard(0xba1) and c:IsType(TYPE_MONSTER)
end
function c9950031.atkval(e,c)
	return Duel.GetMatchingGroupCount(c9950031.atkfilter,c:GetControler(),LOCATION_GRAVE+LOCATION_HAND+LOCATION_MZONE,0,nil)*500
end
function c9950031.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and c:IsChainAttackable(0,true)
end
function c9950031.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c9950031.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToBattle() then return end
	Duel.ChainAttack()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE+PHASE_DAMAGE_CAL)
	c:RegisterEffect(e1)
end
function c9950031.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c9950031.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c9950031.penop(e,tp,eg,ep,ev,re,r,rp)
	 if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end