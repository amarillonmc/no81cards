local m=82204251
local cm=_G["c"..m]
cm.name="烽火骁骑·斯托伦"
function cm.initial_effect(c)
	--fusion material  
	c:EnableReviveLimit()  
	aux.AddFusionProcFunRep2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x129a),2,2,false)  
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)
	--spsummon condition  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)   
	c:RegisterEffect(e1) 
	--act limit
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)  
	e2:SetTargetRange(0,1)  
	e2:SetCondition(cm.accon)
	e2:SetLabel(0x2)
	e2:SetValue(cm.aclimit)   
	c:RegisterEffect(e2) 
	local e3=e2:Clone()
	e3:SetLabel(0x4)
	c:RegisterEffect(e3)
	--immune  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_SINGLE)  
	e4:SetCode(EFFECT_IMMUNE_EFFECT)  
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e4:SetRange(LOCATION_MZONE)  
	e4:SetValue(cm.efilter)  
	c:RegisterEffect(e4)  
end
function cm.efilter(e,te)  
	return te:GetOwner()~=e:GetOwner()  
end  
function cm.accon(e)
	local tp=e:GetHandler():GetControler()
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,e:GetLabel())
end
function cm.aclimit(e,re,tp)  
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(e:GetLabel())
end  