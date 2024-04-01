local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(s.stcost)
	e1:SetTarget(s.sttg)
	e1:SetOperation(s.stop)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		s.check=true
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
		e3:SetTargetRange(LOCATION_SZONE,0)
		e3:SetCondition(s.exrcon)
		e3:SetTarget(s.exrtg)
		e3:SetValue(POS_FACEUP_ATTACK)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e4:SetTargetRange(LOCATION_HAND,0)
		e4:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_FIEND))
		e4:SetLabelObject(e3)
		Duel.RegisterEffect(e4,0)
		local e5=e4:Clone()
		Duel.RegisterEffect(e5,1)
		local f1=Duel.CheckTribute
		Duel.CheckTribute=function(c,min,max_n,g_n,tp_n,zone)
							  s.check=false
							  local result=f2(c,min,max_n,g_n,tp_n,zone)
							  s.check=true
							  return result
						  end
		local f2=Duel.SelectTribute
		Duel.SelectTribute=function(c,min,max_n,g_n,tp_n)
							  s.check=false
							  local result=f2(c,min,max_n,g_n,tp_n)
							  s.check=true
							  return result
						  end
	end
end
function s.exrcon(e)
	return s.check
end
function s.exrtg(e,c)
	return c:GetFlagEffect(id)>0
end
function s.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
end
function s.stfilter(c,e)
	if not c:IsRace(RACE_FIEND) or not c:IsLevel(3) then return false end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP)
	c:RegisterEffect(e1)
	local res=c:IsSSetable()
	e1:Reset()
	return res
end
function s.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.stfilter,tp,LOCATION_DECK,0,1,nil,e) end
end
function s.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,s.stfilter,tp,LOCATION_DECK,0,1,1,nil,e):GetFirst()
	if not tc then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP)
	e1:SetReset(RESET_EVENT+0xee0000)
	tc:RegisterEffect(e1)
	if Duel.SSet(tp,tc)~=0 then tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0) end
end
