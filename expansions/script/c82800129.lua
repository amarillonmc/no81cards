--白玉楼 完全墨染的樱花
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x866)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--summon with 3 tribute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e3:SetCondition(s.ttcon)
	e3:SetOperation(s.ttop)
	e3:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_LIMIT_SET_PROC)
	c:RegisterEffect(e4)
	--summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e5)
	--summon success
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(1102)
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetTarget(s.addct)
	e6:SetOperation(s.addc)
	c:RegisterEffect(e6)
	--immune
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(s.efilter)
	c:RegisterEffect(e7)
	--atk
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_SET_ATTACK_FINAL)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE,EFFECT_FLAG2_WICKED)
	e8:SetRange(LOCATION_MZONE)
	e8:SetValue(s.adval)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_SET_DEFENSE_FINAL)
	c:RegisterEffect(e9)
	--check
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(21208154)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetValue(1)
	c:RegisterEffect(e10)
	--damage
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_DAMAGE)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e11:SetCode(EVENT_PHASE+PHASE_END)
	e11:SetRange(LOCATION_MZONE)
	e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e11:SetCountLimit(1,109402)
	e11:SetTarget(s.damtg)
	e11:SetOperation(s.damop)
	c:RegisterEffect(e11)
	--disable summon
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetRange(LOCATION_ONFIELD)
	e12:SetCode(EFFECT_CANNOT_SUMMON)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e12:SetTargetRange(1,0)
	c:RegisterEffect(e12)
	local e13=e12:Clone()
	e13:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e13)
	local e14=e12:Clone()
	e14:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e14)
end
function s.tlimit(e,c)
	return not c:IsCode(82800114,82800117,82800120,82800144)
end
function s.rsfilter(c)
	return c:IsOriginalCodeRule(82800114,82800117,82800120,82800144)
end
function s.ttcon(e,c,minc)
	if c==nil then return true end
	local g=Duel.GetMatchingGroup(s.rsfilter,tp,LOCATION_MZONE,0,nil)
	return minc<=4 and g:GetClassCount(Card.GetOriginalCode)>3 and Duel.CheckTribute(c,4,4,g)
end
function s.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Group.CreateGroup()
	local sg=nil
	local tg=nil
	local code=82800111
	for i=1,4 do
		if i~=4 then code=code+3 else code=82800144 end
		sg=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,LOCATION_MZONE,0,nil,code)
		tg=Duel.SelectTribute(tp,c,1,1,sg)
		g:Merge(tg)
	end
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function s.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function s.addc(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.filter(c)
	return c:IsFaceup() and not c:IsCode(id) and not c:IsHasEffect(21208154)
end
function s.adval(e,c)
	local g=Duel.GetMatchingGroup(s.filter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then
		return 1000
	else
		local tg,val=g:GetMaxGroup(Card.GetAttack)
		local tg2,val2=g:GetMaxGroup(Card.GetDefense)
		if val2>val then val=val2 end
		return val+1000
	end
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x866)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x866,1)
	end
	if e:GetHandler():GetCounter(0x866)==10 then
		Duel.Damage(1-tp,10000,REASON_EFFECT)
	end
end
