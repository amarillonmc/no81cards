function c10105803.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),10,2)
	c:EnableReviveLimit()
	--unaffected
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c10105803.regcon)
	e1:SetOperation(c10105803.regop)
	c:RegisterEffect(e1)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10105803,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10105803)
	e3:SetCondition(c10105803.descon2)
	e3:SetCost(c10105803.descost2)
	e3:SetTarget(c10105803.destg2)
	e3:SetOperation(c10105803.desop2)
	c:RegisterEffect(e3)
end
function c10105803.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c10105803.regop(e,tp,eg,ep,ev,re,r,rp)
	--unaffected handle after it was summoned
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c10105803.efilter)
	if Duel.GetTurnPlayer()==tp then
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
	end
	e:GetHandler():RegisterEffect(e1)
end
function c10105803.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c10105803.descon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10105803.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLP(tp)-Duel.GetLP(1-tp)>=1000
end
function c10105803.descost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local lp=Duel.GetLP(tp)-Duel.GetLP(1-tp)
	if chk==0 then return Duel.CheckLPCost(tp,lp,true) end
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.PayLPCost(tp,lp,true)
	e:SetLabel(lp)
end
function c10105803.desfilter2(c,num)
	return c:IsFaceup() and c:IsAttackBelow(num)
end
function c10105803.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local lp=Duel.GetLP(tp)-Duel.GetLP(1-tp)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105803.desfilter2,tp,0,LOCATION_MZONE,1,nil,lp) end
	local g=Duel.GetMatchingGroup(c10105803.desfilter2,tp,0,LOCATION_MZONE,nil,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c10105803.gselect(g,num)
	return g:GetSum(Card.GetAttack)<=num
end
function c10105803.desop2(e,tp,eg,ep,ev,re,r,rp)
	local num=e:GetLabel()
	local g=Duel.GetMatchingGroup(c10105803.desfilter2,tp,0,LOCATION_MZONE,nil,num)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=g:SelectSubGroup(tp,c10105803.gselect,false,1,#g,num)
	Duel.Destroy(dg,REASON_EFFECT)
end