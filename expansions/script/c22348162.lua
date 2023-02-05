--支 配 之 线
local m=22348162
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,22348157)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348162,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c22348162.target)
	e1:SetOperation(c22348162.activate)
	c:RegisterEffect(e1)
	--cost
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348162,1))
	e2:SetCategory(CATEGORY_CONTROL+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c22348162.cost)
	e2:SetTarget(c22348162.target2)
	e2:SetOperation(c22348162.activate2)
	c:RegisterEffect(e2)
	
end
function c22348162.thfilter(c)
	return c:IsCode(22348157) and c:IsAbleToHand()
end
function c22348162.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348162.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c22348162.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22348162.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22348162.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c22348162.ntrfilter(c)
	return c:IsControlerCanBeChanged()
end
function c22348162.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingMatchingCard(c22348162.thfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c22348162.ntrfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,LOCATION_MZONE)
end
function c22348162.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22348162.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
	local ctg=Duel.GetMatchingGroup(c22348162.ntrfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and ctg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
			local cttg=ctg:Select(tp,1,1,nil)
			local ctc=cttg:GetFirst()
			local tcp=ctc:GetControler()
			Duel.GetControl(ctc,1-tcp) 
		end
	end
end
