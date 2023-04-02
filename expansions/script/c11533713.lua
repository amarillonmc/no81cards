--刻印之双龙
function c11533713.initial_effect(c) 
	c:EnableReviveLimit()
	--special summon cost
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetCost(c11533713.spcost)
	e0:SetOperation(c11533713.spop)
	c:RegisterEffect(e0)   
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c11533713.sprcon)
	e1:SetOperation(c11533713.sprop)
	c:RegisterEffect(e1) 
	--lp 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) 
	e2:SetCode(EVENT_PHASE+PHASE_END) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1) 
	e2:SetCondition(function(e) 
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer() end) 
	e2:SetOperation(c11533713.lpop) 
	c:RegisterEffect(e2) 
end
function c11533713.spcost(e,c,tp)
	return Duel.GetActivityCount(tp,ACTIVITY_SUMMON)==0
end
function c11533713.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0) 
	e1:SetTarget(c11533713.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c11533713.splimit(e,c,tp,sumtp,sumpos)
	return true 
end
function c11533713.rlgck(g,e,tp) 
	return g:FilterCount(Card.IsControler,nil,tp)==g:FilterCount(Card.IsControler,nil,1-tp) and Duel.GetMZoneCount(tp,g)>0  
end 
function c11533713.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler() 
	local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	return g:CheckSubGroup(c11533713.rlgck,2,99,e,tp)
end
function c11533713.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local rg=g:SelectSubGroup(tp,c11533713.rlgck,false,2,99,e,tp)
	Duel.Release(rg,REASON_COST) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(rg:GetCount()*1000)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT) 
	rg:KeepAlive() 
	e1:SetLabelObject(rg) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(function(e,te) 
	local rg=e:GetLabelObject() 
	return te:IsActiveType(TYPE_MONSTER) and rg:IsExists(Card.IsAttribute,1,nil,te:GetHandler():GetAttribute()) end) 
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1) 
end
function c11533713.lpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local atk=c:GetAttack()/2
	Duel.SetLP(tp,Duel.GetLP(tp)-atk)  
end 




