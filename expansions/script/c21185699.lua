--阿巴阿巴大舌骑士叶
function c21185699.initial_effect(c)
	c:EnableCounterPermit(0x1910,LOCATION_MZONE)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21185699,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_COUNTER+CATEGORY_HANDES)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,21185699)
	e1:SetTarget(c21185699.tg)
	e1:SetOperation(c21185699.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21185699,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,21185699)
	e2:SetCost(c21185699.cost2)
	e2:SetTarget(c21185699.tg2)
	e2:SetOperation(c21185699.op2)
	c:RegisterEffect(e2)
end
function c21185699.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,0)
end
function c21185699.op(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	Duel.Hint(3,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)>0 and c:IsRelateToEffect(e) then
	c:AddCounter(0x1910,1)
	end
end
function c21185699.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x1910)
	if chk==0 then return ct>0 and c:IsCanRemoveCounter(tp,0x1910,ct,REASON_COST) end
	c:RemoveCounter(tp,0x1910,ct,REASON_COST)
	e:SetLabel(ct)
end
function c21185699.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x1910)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,ct*2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct*2)
end
function c21185699.op2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetLabel() then return end
	Duel.Draw(tp,e:GetLabel()*2,REASON_EFFECT)
end