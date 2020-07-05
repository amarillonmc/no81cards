local m=82208109
local cm=_G["c"..m]
cm.name="精灵兽使的长老"
function cm.initial_effect(c)
	--link summon  
	c:SetSPSummonOnce(m)
	--extra summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e1:SetCode(EVENT_SUMMON_SUCCESS)  
	e1:SetOperation(cm.sumop)  
	c:RegisterEffect(e1) 
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)  
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetTargetRange(1,1)  
	e1:SetValue(999)   
	Duel.RegisterEffect(e1,tp)   
end  