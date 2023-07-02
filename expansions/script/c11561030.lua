--花之装 梣
function c11561030.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c11561030.lcheck)
	c:EnableReviveLimit() 
	--immuse 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_IMMUNE_EFFECT) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(function(e,te) 
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer() and te:IsActiveType(TYPE_SPELL) end) 
	c:RegisterEffect(e1) 
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCountLimit(1,2089017)
	e2:SetCondition(c11561030.effcon)
	e2:SetOperation(c11561030.effop)
	c:RegisterEffect(e2)
end
function c11561030.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkRace)==g:GetCount()
end 
function c11561030.effcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_XYZ+REASON_SYNCHRO+REASON_FUSION+REASON_RITUAL)
end
function c11561030.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(11561030,0))
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_IMMUNE_EFFECT) 
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(function(e,te) 
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer() and te:IsActiveType(TYPE_SPELL) end) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1)   
end
