--花忆-「濛」
if not c71401001 then dofile("expansions/script/c71401001.lua") end
function c71401013.initial_effect(c)
	--place
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71401001,3))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,71401013)
	e1:SetCost(yume.ButterflyLimitCost)
	e1:SetTarget(yume.ButterflyPlaceTg)
	e1:SetOperation(yume.ButterflyTrapOp)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71401013,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,71501013)
	e2:SetCondition(c71401013.con2)
	e2:SetCost(c71401013.cost2)
	e2:SetTarget(c71401013.tg2)
	e2:SetOperation(c71401013.op2)
	c:RegisterEffect(e2)
	yume.ButterflyCounter()
end
function c71401013.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c71401013.filterc2(c)
	return c:IsFaceup() and c:GetType() & 0x20004==0x20004 and c:IsAbleToRemoveAsCost()
end
function c71401013.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71401013.filterc2,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) and Duel.GetCustomActivityCount(71401001,tp,ACTIVITY_CHAIN)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c71401013.filterc2,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	yume.RegButterflyCostLimit(e,tp)
end
function c71401013.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c71401013.filter2(c)
	return c:IsFaceup() and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c71401013.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local c=e:GetHandler()
		for sc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(-2000)
			sc:RegisterEffect(e1)
		end
		local dg=Duel.GetDecktopGroup(tp,5)
		if Duel.IsExistingMatchingCard(c71401013.filter2,tp,LOCATION_ONFIELD,0,1,nil) and dg:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)==5 and Duel.SelectYesNo(tp,aux.Stringid(71401013,1)) then
			Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)
		end
	end
end