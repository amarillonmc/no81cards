--恩·达古巴·杰巴
function c25000050.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c25000050.sprcon)
	e2:SetTarget(c25000050.sprtg)
	e2:SetOperation(c25000050.sprop)
	c:RegisterEffect(e2)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e4) 
	--half atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_ATTACK_FINAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c25000050.atkval)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e5:SetValue(c25000050.defval)
	c:RegisterEffect(e5)
	--disable spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_SUMMON)
	e6:SetCountLimit(1,25000050)
	e6:SetCost(c25000050.dscost)
	e6:SetCondition(c25000050.dscon)
	e6:SetTarget(c25000050.dstg)
	e6:SetOperation(c25000050.dsop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e7)
	local e8=e6:Clone()
	e8:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e8)
end
function c25000050.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp)
	return rg:CheckSubGroup(aux.mzctcheckrel,3,3,tp)
end
function c25000050.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsSummonType(SUMMON_TYPE_NORMAL)
end
function c25000050.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetReleaseGroup(tp):Filter(c25000050.cfilter,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,aux.mzctcheckrel,true,3,3,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c25000050.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end
function c25000050.ctfil(c)
	return c:IsReleasable() and c:IsType(TYPE_MONSTER)
end
function c25000050.dscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c25000050.ctfil,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c25000050.ctfil,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c25000050.dscon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c25000050.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end
function c25000050.dsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)
end
function c25000050.atkval(e,c)
	return math.ceil(c:GetAttack()/2)
end
function c25000050.defval(e,c)
	return math.ceil(c:GetDefense()/2)
end
