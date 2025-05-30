-- 龙裔幻殇永续
local s, id = GetID()

function s.initial_effect(c)
	-- Continuous Trap type  
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	-- ①: Destroy same type card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.descost)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	
	-- ②: Destroy facedown when sent to GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.gycon)
	e2:SetTarget(s.gytg)
	e2:SetOperation(s.gyop)
	c:RegisterEffect(e2)
	
	-- ③: Flip face-down when banished
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.rmcon)
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
end

-- ①: Cost function
function s.costfilter(c,types)
	return  (c:IsAbleToGraveAsCost() or c:IsAbleToRemoveAsCost()) and  (c:GetType()&types)~=0
end

function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local types=0
	for tc in aux.Next(g) do
		types=types|(tc:GetType()&(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP))
	end
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler(),types) end

	-- 选择要送去墓地/除外的卡
	local sg=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler(),types)
	local tc=sg:GetFirst()
	local opt=Duel.SelectOption(tp,aux.Stringid(11180016,3),aux.Stringid(11180016,4))
	if opt==0 then
		Duel.SendtoGrave(tc,REASON_COST)
		e:SetLabel(tc:GetType()&(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP))
	else
		Duel.Remove(tc,POS_FACEUP,REASON_COST)
		e:SetLabel(tc:GetType()&(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP))
	end

end

-- ①: Target function
function s.desfilter(c,ty)
	return c:IsFaceup() and c:IsType(ty) 
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ty=e:GetLabel()
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,ty)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end

-- ①: Operation
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local ty=e:GetLabel()
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,ty)
		if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end

-- ②: Condition for being sent to GY


function s.gycon(e,tp,eg,ep,ev,re,r,rp)
	return re and 
		   (re:GetHandler():IsSetCard(0x3450) or re:GetHandler():IsSetCard(0x6450))
end

-- ②: Target for destroying facedown
function s.gyfilter(c)
	return c:IsFacedown() and c:IsCanBeEffectTarget()
end

function s.gytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and s.gyfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.gyfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.gyfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

-- ②: Operation
function s.gyop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

-- ③: Condition for being banished
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return re and 
		   (re:GetHandler():IsSetCard(0x3450) or re:GetHandler():IsSetCard(0x6450))
end

-- ③: Target for flipping face-down
function s.rmfilter(c)
	return c:IsFaceup() and c:IsCanBeEffectTarget() and c:IsCanTurnSet()
end

function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and s.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,s.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end

-- ③: Operation
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
