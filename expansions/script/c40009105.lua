--圣灵守护天使 亚纳菲尔
function c40009105.initial_effect(c)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c40009105.ttcon)
	e1:SetOperation(c40009105.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c40009105.setcon)
	c:RegisterEffect(e2)
	--change effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c40009105.chcon1)
	--e3:SetOperation(c40009105.chop1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c40009105.chcon2)
	e4:SetOperation(c40009105.chop2)
	c:RegisterEffect(e4)  
	--
	local e5=Effect.CreateEffect(c)
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetTarget(c40009105.sumlimit)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e6)  
	--
	local e7=Effect.CreateEffect(c)
	e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_MZONE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(0,1)
	e7:SetCondition(c40009105.descon2)
	e7:SetTarget(c40009105.sumlimit)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e8)  
	--disable
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_DISABLE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(LOCATION_MZONE,0)
	e9:SetTarget(c40009105.distg)
	c:RegisterEffect(e9)
end
function c40009105.distg(e,c)
	return not c:IsRace(RACE_FAIRY)
end
function c40009105.otfilter(c)
	return not c:IsSetCard(40009105) and c:IsRace(RACE_FAIRY) and c:IsReleasable()
end
function c40009105.ttcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c40009105.otfilter,tp,LOCATION_HAND,0,e:GetHandler())
	return minc<=3 and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>=3
		or Duel.CheckTribute(c,1) and mg:GetCount()>=2
		or Duel.CheckTribute(c,2) and mg:GetCount()>=1
		or Duel.CheckTribute(c,3))
end
function c40009105.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c40009105.otfilter,tp,LOCATION_HAND,0,e:GetHandler())
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Group.CreateGroup()
	local ct=3
	while mg:GetCount()>0 and (ct>2 and Duel.CheckTribute(c,ct-2) or ct>1 and Duel.CheckTribute(c,ct-1) or ct>0 and ft>0)
		and (not Duel.CheckTribute(c,ct) or Duel.SelectYesNo(tp,aux.Stringid(40009105,0))) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g1=mg:Select(tp,1,1,nil)
		g:Merge(g1)
		mg:Sub(g1)
		ct=ct-1
	end
	if g:GetCount()<3 then
		local g2=Duel.SelectTribute(tp,c,3-g:GetCount(),3-g:GetCount())
		g:Merge(g2)
	end
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c40009105.setcon(e,c,minc)
	if not c then return true end
	return false
end
function c40009105.chcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
		and Duel.GetLP(e:GetHandlerPlayer())>=12000
end
--function c40009105.chop1(e,tp,eg,ep,ev,re,r,rp)
  --  re:GetHandler():RegisterFlagEffect(40009105,RESET_CHAIN,0,1)
--end
function c40009105.chcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(e:GetHandlerPlayer())>=12000
end
function c40009105.chop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	return Duel.ChangeChainOperation(ev,c40009105.repop)
end
function c40009105.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,40009105)
	Duel.Damage(tp-1,2000,REASON_EFFECT)
	Duel.Recover(tp,2000,REASON_EFFECT)
end
function c40009105.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_FAIRY)
end
function c40009105.descon2(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetLP(e:GetHandlerPlayer())>=15000 or Duel.GetLP(1-tp)>=15000)
end


