--凯尔特·贝奥武夫
function c9950641.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,nil,3,4,c9950641.ovfilter,aux.Stringid(9950641,1),3,c9950641.xyzop)
	c:EnableReviveLimit()
--adup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950641,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1)
	e1:SetCost(c9950641.atkcost)
	e1:SetTarget(c9950641.atktg)
	e1:SetOperation(c9950641.atkop)
	c:RegisterEffect(e1)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9950641.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c9950641.defval)
	c:RegisterEffect(e2)
   --damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950641,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLED)
	e2:SetCondition(c9950641.damcon)
	e2:SetTarget(c9950641.damtg)
	e2:SetOperation(c9950641.damop)
	c:RegisterEffect(e2)
--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950641.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950641.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950641,0))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9950641,2))
end
function c9950641.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6ba2) and not c:IsCode(9950641)
end
function c9950641.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,9950641)==0 end
	Duel.RegisterFlagEffect(tp,9950641,RESET_PHASE+PHASE_END,0,1)
end
function c9950641.atkfilter(c)
	return c:IsSetCard(0x6ba2) and c:GetAttack()>=0
end
function c9950641.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c9950641.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c9950641.deffilter(c)
	return c:IsSetCard(0x6ba2) and c:GetDefense()>=0
end
function c9950641.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c9950641.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c9950641.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9950641.filter(c)
	return c:IsFaceup() 
end
function c9950641.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950641.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function c9950641.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c9950641.filter,tp,0,LOCATION_MZONE,nil)
		local atk=g:GetSum(Card.GetAttack)
		if atk>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e2)
		end
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950641,0))
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9950641,3))
end
function c9950641.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()
end
function c9950641.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,Duel.GetAttackTarget():GetBaseAttack())
end
function c9950641.damop(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttackTarget()
	if bc and bc:IsRelateToBattle() and bc:IsFaceup() then
		Duel.Damage(1-tp,bc:GetBaseAttack(),REASON_EFFECT)
	end
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9950641,3))
end