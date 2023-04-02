--绝高无上 宽容
function c11513060.initial_effect(c)
	c:EnableReviveLimit()
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
	e1:SetCondition(c11513060.sprcon)
	e1:SetOperation(c11513060.sprop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DESTROY) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE) 
	e2:SetTarget(c11513060.destg) 
	e2:SetOperation(c11513060.desop) 
	c:RegisterEffect(e2) 
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	e2:SetCondition(function(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler() end)
	c:RegisterEffect(e2)
	--direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e3) 
	if not c11513060.global_check then
		c11513060.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(c11513060.checkop1)
		Duel.RegisterEffect(ge1,0) 
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c11513060.checkop2)
		Duel.RegisterEffect(ge1,0) 
	end
end
function c11513060.checkop1(e,tp,eg,ep,ev,re,r,rp)
	local flag=Duel.GetFlagEffectLabel(ep,11513060) 
	if flag==nil then 
		Duel.RegisterFlagEffect(ep,11513060,0,0,0,ev) 
	else 
		flag=flag+ev 
		Duel.SetFlagEffectLabel(p,11513060,flag) 
	end 
end
function c11513060.checkop2(e,tp,eg,ep,ev,re,r,rp) 
	local tc=eg:GetFirst()
	while tc do 
		local p=tc:GetControler() 
		local atk=tc:GetAttack()
		local flag=Duel.GetFlagEffectLabel(p,11513060)  
		if flag==nil then 
			Duel.RegisterFlagEffect(p,11513060,0,0,0,atk) 
		else 
			flag=flag+atk 
			Duel.SetFlagEffectLabel(p,11513060,flag) 
		end  
		tc=eg:GetNext()
	end 
end
function c11513060.rlgck(g) 
	return Duel.GetMZoneCount(tp,g)>0 
end 
function c11513060.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler() 
	local x=15 
	local flag=Duel.GetFlagEffectLabel(tp,11513060)  
	if flag then 
	local d=math.floor(flag/400) 
	x=x-d 
	end 
	if x<=0 then x=0 end  
	local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil) 
	return (x>0 and g:CheckSubGroup(c11513060.rlgck,x,x)) or (x==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
end
function c11513060.sprop(e,tp,eg,ep,ev,re,r,rp,c) 
	local tp=c:GetControler() 
	local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil) 
	local x=15 
	local flag=Duel.GetFlagEffectLabel(tp,11513060)  
	if flag then 
	local d=math.floor(flag/400) 
	x=x-d 
	end 
	if x<=0 then x=0 end  
	if x>0 then  
	local sg=g:SelectSubGroup(c11513060.rlgck,x,x)
	Duel.Release(sg,REASON_COST) 
	end 
end
function c11513060.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(11513060,1))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(11513060,1))
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD) 
end 
function c11513060.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil) 
	if g:GetCount()>0 then 
		local dg=g:Select(tp,1,1,nil)  
		Duel.Destroy(dg,REASON_EFFECT) 
	end 
end 




