--作词的时间 今井莉莎
local m=64800067
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	c:RegisterEffect(e1)
	--e2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(cm.cost)
	e2:SetOperation(cm.thop2)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)  
end
function cm.counterfilter(c)  
	return c:GetSummonLocation()~=LOCATION_EXTRA
end  
function cm.filter1(c)
	return c:IsFaceup() and c:GetSummonLocation()==LOCATION_EXTRA
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(cm.filter1,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
-----
--e2
function cm.cfilter(c,tp)
	return c:IsAbleToGraveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_EXTRA,0,1,nil,tp) and Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0  end
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetTargetRange(1,0)  
	e1:SetTarget(cm.splimit)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
	local tc=g:GetFirst()
	local ty=0
	if tc:IsType(TYPE_FUSION) then ty=ty+TYPE_FUSION end
	if tc:IsType(TYPE_SYNCHRO) then ty=ty+TYPE_SYNCHRO end
	if tc:IsType(TYPE_XYZ) then ty=ty+TYPE_XYZ end
	if tc:IsType(TYPE_LINK) then ty=ty+TYPE_LINK end
	if tc:IsType(TYPE_PENDULUM) then ty=ty+TYPE_PENDULUM end
	e:SetLabel(ty)
end
function cm.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
function cm.atkfilter0(e,c)
	return c:IsFaceup() and not c:IsType(e:GetLabel()) and c:GetSummonLocation()==LOCATION_EXTRA
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	local ty=e:GetLabel()
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(cm.distg)
	e1:SetLabel(ty)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetLabel(ty)
	e2:SetTarget(cm.atkfilter0)
	e2:SetValue(cm.atk)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
end
function cm.distg(e,c)
	return c:GetSummonLocation()==LOCATION_EXTRA and not c:IsType(e:GetLabel())
end
function cm.atk(e,c)
	return -c:GetBaseAttack()/2
end