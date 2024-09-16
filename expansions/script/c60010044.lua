--现世光
local cm,m,o=GetID()
function cm.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
cm.xsgs=0
if not cm.xsg then
	cm.xsg=true
	cm._draw=Duel.Draw
	Duel.Draw=function (tp,num,r,...)
		if cm.xsgs~=0 then
			local drawnum=math.min(num,Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)) 
			if drawnum==0 then
				return 0
			else
				return cm._draw(tp,drawnum,r,...)
			end
		elseif cm.xsgs==0 then
			return cm._draw(tp,num,r,...)
		end
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,LOCATION_GRAVE)
	if aux.NecroValleyNegateCheck(g) then return end
	
	Duel.SwapDeckAndGrave(tp)
	Duel.SwapDeckAndGrave(1-tp)

	cm.xsgs=1 

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetOperation(cm.operation2)
	Duel.RegisterEffect(e1,tp)
end

function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,LOCATION_GRAVE)
	if aux.NecroValleyNegateCheck(g) then return end

	Duel.SwapDeckAndGrave(tp)
	Duel.SwapDeckAndGrave(1-tp)
	cm.xsgs=0
	e:Reset()
end