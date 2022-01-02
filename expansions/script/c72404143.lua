
function c72404143.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PLANT),2,99,c72404143.lcheck)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72404143,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCountLimit(1,72404143)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCost(c72404143.cost1)
	e1:SetTarget(c72404143.target1)
	e1:SetOperation(c72404143.operation1)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72404143,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,72404144)
	e3:SetCondition(c72404143.condition3)
	e3:SetOperation(c72404143.operation3)
	c:RegisterEffect(e3)
end
function c72404143.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x720)
end
--e1
function c72404143.costfilter1(c,e)
	return c:IsRace(RACE_PLANT) and c:IsReleasable()
end
function c72404143.costfilter2(c,e)
	return c:IsFaceup() and c:IsReleasable()
end
function c72404143.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c72404143.costfilter1,1,e:GetHandler(),e) and  Duel.IsExistingMatchingCard(c72404143.costfilter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupEx(tp,c72404143.costfilter1,1,1,e:GetHandler(),e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectMatchingCard(tp,c72404143.costfilter2,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.Release(g+rg,REASON_COST)
end
function c72404143.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1200)
end
function c72404143.operation1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end

--e2
function c72404143.confilter3(c,tp)
	return c:IsType(TYPE_MONSTER)  and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp
end
function c72404143.condition3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c72404143.confilter3,1,e:GetHandler(),tp)
end

function c72404143.operation3(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetLinkedGroup()
	local c=e:GetHandler()
	Group.AddCard(g,c)
	local tg=Group.GetFirst(g)
	while tg do
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(72404143,2))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tg:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)   
	tg:RegisterEffect(e2) 
	tg=g:GetNext()
	end
end

--function c72404143.indtg(e,c)
   -- return c==e:GetHandler()
	--  or c:IsFaceup() and c:IsRace(RACE_PLANT) and e:GetHandler():GetLinkedGroup():IsContains(c)
--end