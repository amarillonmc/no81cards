--惑星壳·毒尾
function c79029571.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,c79029571.ffilter,2,63,true)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c79029571.efilter)
	e4:SetCondition(c79029571.imcon)
	c:RegisterEffect(e4)	
	--battle target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(aux.imval1)
	c:RegisterEffect(e5)
	--Target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)  
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3) 
	--SSet
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c79029571.sscon)
	e1:SetTarget(c79029571.sstg)
	e1:SetOperation(c79029571.ssop)
	c:RegisterEffect(e1)
	--disable field
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_DISABLE_FIELD)
	e7:SetProperty(EFFECT_FLAG_REPEAT+EFFECT_FLAG_CLIENT_HINT)
	e7:SetOperation(c79029571.disop)
	c:RegisterEffect(e7)
	--atk def
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_CHAINING)
	e6:SetOperation(c79029571.auop)
	c:RegisterEffect(e6)
end
function c79029571.ffilter(c,fc)
	return c:IsRace(RACE_INSECT) or c:IsRace(RACE_PLANT)
end
function c79029571.efilter(e,te)
	return te:GetOwner():GetControler()~=e:GetOwner():GetControler()
end
function c79029571.fil(c)
	return c:IsType(TYPE_XYZ)
end
function c79029571.imcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  c:GetMaterial():IsExists(c79029571.fil,1,nil)
end
function c79029571.sscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c79029571.ssfil(c,e)
	return c:IsSSetable() and c:IsType(TYPE_TRAP)
end
function c79029571.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local x1=e:GetHandler():GetMaterialCount()
	local x2=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if x1>x2 then x1,x2=x2,x1 end
	if chk==0 then return  Duel.GetMatchingGroupCount(c79029571.ssfil,tp,LOCATION_DECK,0,nil,e)>=1 end
	local g=Duel.SelectMatchingCard(tp,c79029571.ssfil,tp,LOCATION_DECK,0,1,x1,nil,e)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,g,nil,tp,LOCATION_DECK)
end
function c79029571.ssop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	while tc do
	if Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	tc=g:GetNext()
	end
	end
end
function c79029571.disfil(c)
	return c:IsFacedown() and c:GetSequence()<5
end
function c79029571.disop(e,tp)   
	local g=Duel.GetMatchingGroup(c79029571.disfil,tp,LOCATION_SZONE,0,nil)
	local tc=g:GetFirst()
	local flag=0
	while tc do
	local seq=tc:GetSequence()
	local x=bit.lshift(0x1,24+math.abs(4-seq))
	flag=bit.bor(flag,x)
	tc=g:GetNext()
	end
	return flag
end
function c79029571.auop(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetFirst():IsType(TYPE_TRAP) and rp==tp then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e:GetHandler():RegisterEffect(e2)
end 
end


