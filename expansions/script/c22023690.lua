--日轮的宠姬
function c22023690.initial_effect(c)
	aux.AddCodeList(c,22020631)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22023690+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c22023690.cost)
	e1:SetTarget(c22023690.target)
	e1:SetOperation(c22023690.operation)
	c:RegisterEffect(e1)
end
function c22023690.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsCode,1,nil,22020631) end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct>3 then ct=3 end
	local g=Duel.SelectReleaseGroup(tp,Card.IsCode,1,ct,nil,22020631)
	local rct=Duel.Release(g,REASON_COST)
	e:SetLabel(rct)
end
function c22023690.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel())
end
function c22023690.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,e:GetLabel(),REASON_EFFECT)
end
