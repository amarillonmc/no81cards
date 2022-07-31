local m=15004202
local cm=_G["c"..m]
cm.name="虚实写笔-恶魔"
function cm.initial_effect(c)
	--Dual
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DUAL_SUMMONABLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.VNormalCondition)
	e2:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_REMOVE_TYPE)
	e3:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e3)
	--change base attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.VNormalCondition)
	e4:SetCode(EFFECT_SET_BASE_ATTACK)
	e4:SetValue(1900)
	c:RegisterEffect(e4)
	--Destroy
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetCountLimit(1,15004202)
	e5:SetCondition(cm.scon)
	e5:SetTarget(cm.stg)
	e5:SetOperation(cm.sop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCountLimit(1,15004203)
	c:RegisterEffect(e6)
	--DualState
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.dacon)
	e3:SetOperation(cm.daop)
	c:RegisterEffect(e3)
end
function cm.VNormalCondition(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsDualState()
end
function cm.smfilter(c,tp)
	return c:IsCode(15004202) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,c) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function cm.spfilter(c,sc)
	return c:IsSynchroSummonable(sc) and c:IsSetCard(0x6f31)
end
function cm.scon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_EFFECT)
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local ag=Duel.SelectMatchingCard(tp,cm.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	if ag:GetCount()==0 then return end
	if ag:GetFirst():IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tp,ag) end
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_EXTRA,0,nil,ag:GetFirst())
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),ag:GetFirst())
	end
end
function cm.dacon(e,tp,eg,ep,ev,re,r,rp)
	return ((not e:GetHandler():IsDualState()) and (not re:GetHandler():IsCode(15004202)))
end
function cm.daop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,15004202)
	e:GetHandler():EnableDualState()
end