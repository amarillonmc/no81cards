local m=82208132
local cm=_G["c"..m]
cm.name="龙法师 死球之重压"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetLabel(0)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.operation)  
	c:RegisterEffect(e1)
	--act in hand  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)  
	e2:SetCondition(cm.handcon)  
	c:RegisterEffect(e2)  
end  
function cm.cfilter(c)  
	return c:IsSetCard(0x6299) and c:IsDiscardable()  
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,c) end  
	local tc=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,c):GetFirst()
	if tc:IsType(TYPE_MONSTER) then
		e:SetLabel(TYPE_MONSTER)
	else
		if tc:IsType(TYPE_SPELL) then
			e:SetLabel(TYPE_SPELL)
		else
			if tc:IsType(TYPE_TRAP) then
				e:SetLabel(TYPE_TRAP)
			end
		end
	end
	Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
end  
function cm.operation(e,tp,eg,ep,ev,re,r,rp) 
	local lab=e:GetLabel()
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)  
	e1:SetTargetRange(0,1)  
	e1:SetValue(cm.aclimit)  
	e1:SetLabel(lab)
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)  
end  
function cm.aclimit(e,re,tp)  
	return re:GetHandler():IsType(e:GetLabel())
end
function cm.hdfilter(c)
	return c:IsFaceup() and not c:IsSetCard(0x6299)
end
function cm.handcon(e,tp,eg,ep,ev,re,r,rp)  
	local p=e:GetHandler():GetControler()
	return not Duel.IsExistingMatchingCard(cm.hdfilter,p,LOCATION_MZONE,0,1,nil)
end  