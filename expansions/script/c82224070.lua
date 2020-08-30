local m=82224070
local cm=_G["c"..m]
cm.name="魔偶甜点祈愿"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1) 
	--Negate  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e3:SetCode(EVENT_CHAIN_SOLVING)  
	e3:SetRange(LOCATION_SZONE)  
	e3:SetCondition(cm.negcon)  
	e3:SetOperation(cm.negop)  
	c:RegisterEffect(e3)  
	--indes  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD)  
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)  
	e4:SetRange(LOCATION_SZONE)  
	e4:SetTargetRange(LOCATION_MZONE,0)  
	e4:SetTarget(cm.indtg)  
	e4:SetValue(cm.indct)  
	c:RegisterEffect(e4)  
end
function cm.indtg(e,c)  
	return c:IsSetCard(0x71)  
end  
function cm.indct(e,re,r,rp)  
	if bit.band(r,REASON_BATTLE)~=0 then  
		return 1  
	else return 0 end  
end  
function cm.cfilter(c)  
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x71) 
end  
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():GetFlagEffect(m)==0 and rp~=tp and Duel.IsChainDisablable(ev) and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end  
function cm.negop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then  
		Duel.Hint(HINT_CARD,0,m)  
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)  
		if Duel.NegateEffect(ev) then  
			Duel.Destroy(re:GetHandler(),REASON_EFFECT)  
		end  
	end  
end 