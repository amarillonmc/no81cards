local m=90700055
local cm=_G["c"..m]
cm.name="归亡引导 恐怖利刃"
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(cm.dualcon)
	e0:SetOperation(cm.dualop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetValue(SUMMON_VALUE_SELF)
	e1:SetCondition(cm.dualscon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCondition(aux.DualNormalCondition)
	e2:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_REMOVE_TYPE)
	e3:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_DRAW)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(aux.IsDualState)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_SEND_REPLACE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(aux.IsDualState)
	e5:SetTarget(cm.reptg)
	e5:SetValue(cm.repval)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)
	local e8=e4:Clone()
	e8:SetCode(EVENT_SUMMON)
	c:RegisterEffect(e8)
	local e9=e4:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
	local e10=e4:Clone()
	e10:SetCode(EVENT_SSET)
	c:RegisterEffect(e10)
	local e11=e4:Clone()
	e11:SetCode(EVENT_RELEASE)
	c:RegisterEffect(e11)
	local e12=e4:Clone()
	e12:SetCode(EVENT_DESTROY)
	c:RegisterEffect(e12)
end
function cm.dualcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF 
end
function cm.dualop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():EnableDualState()
end
function cm.dualscon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return not c:IsDualState() and c:IsCanBeSpecialSummoned(e,1,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local reg=Group.CreateGroup()
	while tc do
		if tc:IsPreviousLocation(LOCATION_DECK) and tc:IsControler(1-tp) then
			reg:AddCard(tc)
		end
		tc=eg:GetNext()
	end
	local fdg=reg:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	Duel.Remove(reg,POS_FACEDOWN,REASON_RULE)
	Duel.ChangePosition(fdg,POS_FACEDOWN)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) end
	local reg=eg:Filter(Card.IsLocation,nil,LOCATION_DECK):Filter(Card.IsControler,nil,1-tp)
	Duel.Remove(reg,POS_FACEDOWN,REASON_RULE)
	return true
end
function cm.repval(e,c)
	return false
end