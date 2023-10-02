--冼梦阑
local cm,m,o=GetID()
function cm.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
if not cm.xml_change_operation then
	cm.xml_change_operation=true
	cm._send_to_hand=Duel.SendtoHand
	Duel.SendtoHand=function (c,b,x,...)
		local sol=0
		local tc=0
		local num=0
		local tp=0
		if aux.GetValueType(c)=="Card" then
			tc=c
		elseif aux.GetValueType(c)=="Group" then
			tc=c:GetFirst()
		end
		if b==nil then
			tp=tc:GetControler()
		else
			tp=b
		end
		if Duel.GetFlagEffect(1-tp,60002373)~=0 then
			if aux.GetValueType(c)=="Card" then
				tc=c
				num=1
				Duel.Hint(HINT_CARD,0,tc:GetCode())
				if tc:IsLocation(LOCATION_DECK) then
					Duel.Draw(tp,1,x)
				end
			elseif aux.GetValueType(c)=="Group" then
				tc=c:GetFirst()
				num=c:GetCount()
				while tc do
					Duel.Hint(HINT_CARD,0,tc:GetCode())
					if tc:IsLocation(LOCATION_DECK) then
						num=num+1
					else
						cm._send_to_hand(tc,b,x,...)
					end
					tc=c:GetNext()
				end
				Duel.Draw(tp,num-1,x)
			end
		else
			cm._send_to_hand(c,b,x,...)
			sol=num
		end
		return sol
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end