--混沌No.62 银河眼光子龙皇-源数之门
function c9952014.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,4,c9952014.ovfilter,aux.Stringid(9952014,0))
	c:EnableReviveLimit()
 --atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9952014,3))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c9952014.atkcon)
	e1:SetCost(c9952014.atkcost)
	e1:SetOperation(c9952014.atkop)
	c:RegisterEffect(e1)
--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9952014,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c9952014.spcon)
	e2:SetOperation(c9952014.spop)
	c:RegisterEffect(e2)
   --negate activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9952014,2))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c9952014.negcon)
	e2:SetCost(c9952014.negcost)
	e2:SetTarget(c9952014.negtg)
	e2:SetOperation(c9952014.negop)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9952014.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9952014.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9952014,4))
end
c9952014.xyz_number=62
function c9952014.ovfilter(c)
	return c:IsFaceup() and c:IsCode(31801517)
end
function c9952014.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==Duel.GetAttacker() or c==Duel.GetAttackTarget()
end
function c9952014.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) and c:GetFlagEffect(9952014)==0 end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	c:RegisterFlagEffect(9952014,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c9952014.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local val=g:GetSum(Card.GetRank)*300
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		c:RegisterEffect(e1)
	end
end
function c9952014.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousControler()==tp and rp==1-tp 
		and c:IsPreviousLocation(LOCATION_MZONE) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9952014.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_REMOVED+LOCATION_GRAVE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	if Duel.GetCurrentPhase()==PHASE_STANDBY and Duel.GetTurnPlayer()==tp then
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,3)
	else
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	end
	e1:SetCountLimit(1)
	e1:SetCondition(c9952014.spcon2)
	e1:SetOperation(c9952014.spop2)
	c:RegisterEffect(e1)
	c:SetTurnCounter(0)
end
function c9952014.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c9952014.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==2 then
		Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(c:GetAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
function c9952014.negcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return ep~=tp
		and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainDisablable(ev)
end
function c9952014.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local ct=Duel.GetOperatedGroup():GetFirst()
	e:SetLabelObject(ct)
end
function c9952014.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and e:GetLabelObject():IsSetCard(0x7b) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,re:GetHandler(),1,0,0)
	end
end
function c9952014.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) and e:GetLabelObject():IsSetCard(0x7b) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end