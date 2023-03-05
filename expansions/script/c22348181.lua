--遥 远 之 民 素 莹 害 兽
local m=22348181
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(c22348181.sprcon)
	c:RegisterEffect(e0)
	--effect gain
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348181,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c22348181.xyzcon0)
	e1:SetTarget(c22348181.tgtg)
	e1:SetOperation(c22348181.tgop)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c22348181.xyzcon)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c22348181.eftg)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetLabelObject(e2)
	c:RegisterEffect(e4)
	--effect gain
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c22348181.efilter1)
	e6:SetCondition(c22348181.tgcon1)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(c22348181.efilter2)
	e7:SetCondition(c22348181.tgcon2)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_UPDATE_ATTACK)
	e8:SetValue(500)
	local e9=e3:Clone()
	e9:SetLabelObject(e6)
	c:RegisterEffect(e9)
	local e10=e3:Clone()
	e10:SetLabelObject(e7)
	c:RegisterEffect(e10)
	local e11=e3:Clone()
	e11:SetLabelObject(e8)
	c:RegisterEffect(e11)
end
function c22348181.xyzcon0(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsType(TYPE_XYZ)
end
function c22348181.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_XYZ)
end
function c22348181.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c22348181.efilter1(e,re,rp)
	return aux.tgoval(e,re,rp) and re:IsActiveType(TYPE_MONSTER)
end
function c22348181.efilter2(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c22348181.tgcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()<4
end
function c22348181.tgcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()==4
end
function c22348181.eftg(e,c)
	local seq=c:GetSequence()
	return c:IsType(TYPE_EFFECT) and c:IsOriginalSetCard(0x706)
		and seq<5 and e:GetHandler():GetSequence()<seq
end
function c22348181.tgfilter(c)
	return c:IsSetCard(0x706) and c:IsAbleToGrave()
end
function c22348181.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348181.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c22348181.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22348181.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end









