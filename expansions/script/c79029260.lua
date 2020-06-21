--罗德岛·术士干员-阿米娅·奇美拉
function c79029260.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c79029260.spcon)
	e1:SetOperation(c79029260.spop)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--win
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c79029260.winop)
	c:RegisterEffect(e4)
end
function c79029260.spfilter(c,counter)
	return c:GetCounter(0x1099)>=10
end
function c79029260.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(tp,c79029260.spfilter,1,nil,79029037)
end
function c79029260.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c79029260.spfilter,1,1,nil,79029037)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	c:RegisterFlagEffect(79029260,0,0,0)
end
function c79029260.winop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(79029260)==0 then return end
	local WIN_REASON_AYMIA=0x0a
	local p=e:GetHandler():GetSummonPlayer()
	Duel.Win(p,WIN_REASON_AYMIA) 
end
