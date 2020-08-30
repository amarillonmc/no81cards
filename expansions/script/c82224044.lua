local m=82224044
local cm=_G["c"..m]
cm.name="重生之翼"
function cm.initial_effect(c)
	--link summon  
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),1)  
	c:EnableReviveLimit()  
	--effect gain  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e2:SetCondition(cm.regcon)  
	e2:SetOperation(cm.regop)  
	c:RegisterEffect(e2) 
	--cannot link material  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE)  
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)  
	e3:SetValue(1)  
	c:RegisterEffect(e3)  
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)  
end  
function cm.regop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	if c:GetMaterialCount()>=1 then
		local ct=c:GetMaterialCount()
		--set base atk
		local e6=Effect.CreateEffect(c)  
		e6:SetType(EFFECT_TYPE_SINGLE)  
		e6:SetCode(EFFECT_SET_BASE_ATTACK)  
		e6:SetValue(ct*1000)  
		e6:SetReset(RESET_EVENT+0xff0000)  
		c:RegisterEffect(e6)   
	end
	if c:GetMaterialCount()>=2 then
		--immune to monster
		local e1=Effect.CreateEffect(c) 
		e1:SetDescription(aux.Stringid(m,1)) 
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_IMMUNE_EFFECT)  
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_SINGLE_RANGE)  
		e1:SetRange(LOCATION_MZONE)  
		e1:SetValue(cm.efilter1)  
		c:RegisterEffect(e1) 
	end
	if c:GetMaterialCount()>=3 then
		--immune to spell/trap
		local e2=Effect.CreateEffect(c)  
		e2:SetDescription(aux.Stringid(m,2))
		e2:SetType(EFFECT_TYPE_SINGLE)  
		e2:SetCode(EFFECT_IMMUNE_EFFECT)  
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_SINGLE_RANGE)  
		e2:SetRange(LOCATION_MZONE)  
		e2:SetValue(cm.efilter2)  
		c:RegisterEffect(e2) 
	end
	if c:GetMaterialCount()>=4 then
		--reflect damage  
		local e3=Effect.CreateEffect(c)  
		e3:SetDescription(aux.Stringid(m,3))
		e3:SetType(EFFECT_TYPE_FIELD)  
		e3:SetCode(EFFECT_REFLECT_DAMAGE)  
		e3:SetRange(LOCATION_MZONE)  
		e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_PLAYER_TARGET)  
		e3:SetTargetRange(1,0)  
		e3:SetValue(cm.refcon)  
		c:RegisterEffect(e3) 
	end
	if c:GetMaterialCount()>=5 then
		--cannot chain  
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(m,4))  
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
		e4:SetCode(EVENT_CHAINING) 
		e4:SetProperty(EFFECT_FLAG_CLIENT_HINT) 
		e4:SetRange(LOCATION_MZONE)  
		e4:SetOperation(cm.ccop)  
		c:RegisterEffect(e4)  
	end 
	if c:GetMaterialCount()==6 then 
		--destroy  
		local e5=Effect.CreateEffect(c)  
		e5:SetDescription(aux.Stringid(m,5))  
		e5:SetCategory(CATEGORY_DESTROY)  
		e5:SetType(EFFECT_TYPE_IGNITION) 
		e5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e5:SetCountLimit(1)  
		e5:SetRange(LOCATION_MZONE)  
		e5:SetTarget(cm.destg)  
		e5:SetOperation(cm.desop)  
		c:RegisterEffect(e5) 
	end
end
function cm.efilter1(e,re)  
	return re:IsActiveType(TYPE_MONSTER) and re:GetOwner()~=e:GetOwner()  
end  
function cm.efilter2(e,re)  
	return re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)
end  
function cm.refcon(e,re,val,r,rp,rc)  
	return true 
end  
function cm.ccop(e,tp,eg,ep,ev,re,r,rp)  
	if ep==tp then  
		Duel.SetChainLimit(cm.chainlm)  
	end  
end  
function cm.chainlm(e,rp,tp)  
	return tp==rp  
end  
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end  
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)  
end  
function cm.desop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)  
	Duel.Destroy(g,REASON_EFFECT)  
end  