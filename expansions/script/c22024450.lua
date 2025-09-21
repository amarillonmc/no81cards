--予天以星
function c22024450.initial_effect(c)
	aux.AddCodeList(c,22020130)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22024450+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c22024450.con)
	e1:SetTarget(c22024450.target)
	e1:SetOperation(c22024450.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_COIN)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,22024450+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c22024450.con1)
	e2:SetTarget(c22024450.target1)
	e2:SetOperation(c22024450.activate1)
	c:RegisterEffect(e2)
end
c22024450.toss_coin=true
function c22024450.cfilter(c)
	return c:IsCode(22020130) and c:IsFaceup()
end
function c22024450.con(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c22024450.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c22024450.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,3)
end
function c22024450.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local c1,c2=Duel.TossCoin(tp,2)
	if c1+c2==0 then
		Duel.Draw(1-tp,2,REASON_EFFECT)
	end
	if c1+c2==1 then
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
	if c1+c2==2 then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end

function c22024450.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22024450.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c22024450.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,3)
end
function c22024450.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local c1,c2,c3=Duel.TossCoin(tp,3)
	if c1+c2+c3==0 then
		Duel.Draw(1-tp,3,REASON_EFFECT)
	end
	if c1+c2+c3==1 then
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.Draw(1-tp,2,REASON_EFFECT)
	end
	if c1+c2+c3==2 then
		Duel.Draw(tp,2,REASON_EFFECT)
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
	if c1+c2+c3==3 then
		Duel.Draw(tp,3,REASON_EFFECT)
	end
end