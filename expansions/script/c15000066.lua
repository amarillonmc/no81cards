local m=15000066
local cm=_G["c"..m]
cm.name="与色带神的契约"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(15000066,0))  
	e2:SetCategory(CATEGORY_DESTROY)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetCountLimit(1)  
	e2:SetCondition(c15000066.descon)
	e2:SetOperation(c15000066.desop)  
	c:RegisterEffect(e2)
	--atk up  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetCode(EFFECT_UPDATE_ATTACK)  
	e3:SetRange(LOCATION_SZONE)  
	e3:SetTargetRange(LOCATION_MZONE,0)  
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xf33))  
	e3:SetCondition(c15000066.p1con)
	e3:SetValue(300)  
	c:RegisterEffect(e3)
	--chainlim
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e4:SetCode(EVENT_CHAINING) 
	e4:SetRange(LOCATION_SZONE) 
	e4:SetCondition(c15000066.p2con)
	e4:SetOperation(c15000066.actop) 
	c:RegisterEffect(e4)  
	--Cannot target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xf33))
	e5:SetValue(c15000066.evalue)
	c:RegisterEffect(e5)
	--change Pscale
	local e6=Effect.CreateEffect(c) 
	e6:SetType(EFFECT_TYPE_FIELD)  
	e6:SetCode(EFFECT_CHANGE_LSCALE)  
	e6:SetTargetRange(LOCATION_PZONE,LOCATION_PZONE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c15000066.p4con)
	e6:SetValue(4)
	c:RegisterEffect(e6)
	local e7=e6:Clone()  
	e7:SetCode(EFFECT_CHANGE_RSCALE)
	e7:SetValue(4)
	c:RegisterEffect(e7)
end
function c15000066.evalue(e,re,rp)
	return re:IsActiveType(TYPE_SPELL) and rp==1-e:GetHandlerPlayer()
end
function c15000066.desfilter(c)  
	return c:IsDestructable()
end
function c15000066.pfilter(c)  
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c15000066.descon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(c15000066.desfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil) 
end
function c15000066.desop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.SelectMatchingCard(tp,c15000066.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()~=0 then
		local tc=g:GetFirst()
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c15000066.p1con(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetMatchingGroupCount(c15000066.pfilter,e:GetHandlerPlayer(),LOCATION_PZONE,LOCATION_PZONE,nil)>=1
end
function c15000066.p2con(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetMatchingGroupCount(c15000066.pfilter,e:GetHandlerPlayer(),LOCATION_PZONE,LOCATION_PZONE,nil)>=2
end
function c15000066.actop(e,tp,eg,ep,ev,re,r,rp)  
	local rc=re:GetHandler()  
	if re:IsActiveType(TYPE_MONSTER) and rc:IsSetCard(0xf33) and ep==tp then  
		Duel.SetChainLimit(c15000066.chainlm)  
	end  
end  
function c15000066.chainlm(e,rp,tp)  
	return not (tp~=rp and e:IsActiveType(TYPE_TRAP))
end
function c15000066.p3con(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetMatchingGroupCount(c15000066.pfilter,e:GetHandlerPlayer(),LOCATION_PZONE,LOCATION_PZONE,nil)>=3
end
function c15000066.atklimit(e,c)  
	return c:IsDisabled()
end
function c15000066.p4con(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetMatchingGroupCount(c15000066.pfilter,e:GetHandlerPlayer(),LOCATION_PZONE,LOCATION_PZONE,nil)==4
end