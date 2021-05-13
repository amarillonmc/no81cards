--梦坠
function c71400013.initial_effect(c)
	--Activate(nofield)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400013,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetCondition(c71400013.condition1)
	e1:SetTarget(c71400013.target1)
	e1:SetCost(c71400013.cost)
	e1:SetOperation(c71400013.operation1)
	e1:SetCountLimit(1,71400013+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--Activate(field)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400013,2))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c71400013.condition2)
	e2:SetTarget(c71400013.target2)
	e2:SetCost(c71400013.cost)
	e2:SetOperation(c71400013.operation2)
	e2:SetCountLimit(1,71400013+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e2)
end
function c71400013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c71400013.condition1(e,tp,eg,ep,ev,re,r,rp)
	tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	return tc==nil or tc:IsFacedown() or not tc:IsSetCard(0x3714)
end
function c71400013.condition2(e,tp,eg,ep,ev,re,r,rp)
	tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	return tc and tc:IsFaceup() and tc:IsSetCard(0x3714)
end
function c71400013.filter1(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true) and c:IsSetCard(0xb714)
end
function c71400013.filter1a(c)
	return c:IsFaceup() and c:IsAbleToGrave()
end
function c71400013.filter2(c)
	return c:IsSetCard(0x714) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c71400013.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=yume.ActivateYumeField(tp,nil,1)
	local dg=Duel.GetMatchingGroup(c71400013.filter1a,tp,0,LOCATION_ONFIELD,nil)
	if tc and dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71400013,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local des=dg:Select(tp,1,1,nil)
		Duel.HintSelection(des)
		Duel.BreakEffect()
		Duel.SendtoGrave(des,REASON_EFFECT)
	end
	local el1=Effect.CreateEffect(c)
	el1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	el1:SetType(EFFECT_TYPE_FIELD)
	el1:SetCode(EFFECT_CANNOT_SUMMON)
	el1:SetTarget(c71400013.sumlimit)
	el1:SetTargetRange(1,0)
	el1:SetReset(RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(el1,tp)
	local el2=el1:Clone()
	el2:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(el2)
	local el3=el1:Clone()
	el3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(el3)
end
function c71400013.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c71400013.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,nil,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		if og:GetCount()==2 then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_SOLVING)
			e1:SetCondition(c71400013.discon)
			e1:SetOperation(c71400013.disop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
	local el1=Effect.CreateEffect(c)
	el1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	el1:SetType(EFFECT_TYPE_FIELD)
	el1:SetCode(EFFECT_CANNOT_SUMMON)
	el1:SetTarget(c71400013.sumlimit)
	el1:SetTargetRange(1,0)
	el1:SetReset(RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(el1,tp)
	local el2=el1:Clone()
	el2:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(el2)
	local el3=el1:Clone()
	el3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(el3)
end
function c71400013.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and rp==1-tp and re:GetActivateLocation()&(LOCATION_MZONE+LOCATION_GRAVE)~=0
end
function c71400013.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c71400013.sumlimit(e,c)
	return not c:IsSetCard(0x714)
end
function c71400013.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return yume.YumeFieldCheck(tp,0,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,1-tp,LOCATION_ONFIELD)
end
function c71400013.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400013.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_HAND+LOCATION_ONFIELD)
end