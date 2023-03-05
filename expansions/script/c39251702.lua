--电子龙 光变
local m=39251702
local cm=_G["c"..m]
function cm.initial_effect(c)
	--code
	aux.EnableChangeCode(c,70095154,LOCATION_MZONE+LOCATION_GRAVE)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--lv
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.lvcon)
	e2:SetCost(cm.lvcost)
	e2:SetTarget(cm.lvtg)
	e2:SetOperation(cm.lvop)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCountLimit(999)
	e3:SetCondition(cm.spcon2)
	e3:SetOperation(cm.spop2)
	c:RegisterEffect(e3)
end
function cm.spfilter(c)
	return c:IsLevelBelow(4) and c:IsSetCard(0x1093)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>=1
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,0,1,tp,LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)~=0 
end
function cm.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
--return Duel.GetFlagEffect(tp,m)~=0 end
--Duel.GetCustomActivityCount(59281922,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)  
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetRace()~=RACE_MACHINE
end
function cm.filter(c)
	return c:IsLevelBelow(4) and c:IsSetCard(0x1093)
end
function cm.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function cm.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(5)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function cm.spcon2(e,c)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)<1
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(m,1))
end
