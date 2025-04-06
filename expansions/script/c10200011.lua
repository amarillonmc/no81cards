--渊灵-潜渊盲鳗
function c10200011.initial_effect(c)
    aux.EnablePendulumAttribute(c)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10200011,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xe21))
	e1:SetValue(500)
	c:RegisterEffect(e1)
	--战吼复制
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,10200011)
	e2:SetTarget(c10200011.tg1)
	e2:SetOperation(c10200011.op1)
	c:RegisterEffect(e2)
	c10200011.zhanhou_effect=e2
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    --遗言复制
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10200011,2))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,10200012)
	e4:SetTarget(c10200011.tg2)
	e4:SetOperation(c10200011.op2)
	c:RegisterEffect(e4)
	c10200011.yiyan_effect=e4
end
-- 1
function c10200011.filter1(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0xe21) and c:IsAbleToGrave()) then return false end
	local te=c.yiyan_effect
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function c10200011.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local check=true
	local ct=Duel.GetChainInfo(0,CHAININFO_CHAIN_COUNT)
	if ct then
		for i=1,ct do
			local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			if te:GetHandler()==e:GetHandler() then check=false end
		end
	end
	if chk==0 then return Duel.IsExistingMatchingCard(c10200011.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,eg,ep,ev,re,r,rp) and check end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c10200011.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c10200011.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
		local te=tc.yiyan_effect
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
-- 2
function c10200011.filter2(c)
	if not (c:IsSetCard(0xe21) and c:IsAbleToGrave()) then return false end
	local te=c.zhanhou_effect
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function c10200011.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local check=true
	local ct=Duel.GetChainInfo(0,CHAININFO_CHAIN_COUNT)
	if ct then
		for i=1,ct do
			local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			if te:GetHandler()==e:GetHandler() then check=false end
		end
	end
	if chk==0 then return Duel.IsExistingMatchingCard(c10200011.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,eg,ep,ev,re,r,rp) and check end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c10200011.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c10200011.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
		local te=tc.zhanhou_effect
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end