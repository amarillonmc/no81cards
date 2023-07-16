--俱灭之白骨圣堂教主II
local m=60002192
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(cm.con)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.fil(c)
	return c:IsType(TYPE_MONSTER) and not c:IsCode(m)
end
function cm.con(e,tp)
	return Duel.GetFlagEffect(tp,m)==0
end
function cm.op(e,tp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(cm.fil,tp,LOCATION_HAND+LOCATION_DECK,LOCATION_HAND+LOCATION_DECK,nil) 
	Duel.Hint(HINT_CARD,0,m) 
	local tc=g:GetFirst() 
	while tc do  
		tc:SetCardData(CARDDATA_CODE,32274490) 
		tc:ReplaceEffect(32274490,0,1) 
		tc=g:GetNext() 
	end   
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1000)
end
