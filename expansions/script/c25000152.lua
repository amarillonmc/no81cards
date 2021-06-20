local m=25000152
local cm=_G["c"..m]
cm.name="究极合体怪兽 基伽奇美拉"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,5,false)
	--mat check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(cm.matcheck)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,5))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.negcon)
	e2:SetTarget(cm.negtg)
	e2:SetOperation(cm.negop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,6))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(cm.rmtg)
	e3:SetOperation(cm.rmop)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
	--client hint
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(cm.regcon)
	e4:SetOperation(cm.regop)
	e4:SetLabelObject(e1)
	c:RegisterEffect(e4)
end
function cm.ffilter(c,fc,sub,mg,sg)
	return (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode())) and c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
end
function cm.matcheck(e,c)
	local g=c:GetMaterial():Filter(Card.IsType,nil,TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
	local type1=0
	local tc=g:GetFirst()
	while tc do
		type1=bit.bor(type1,tc:GetType())
		tc=g:GetNext()
	end
	e:SetLabel(type1)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local type1=e:GetLabelObject():GetLabel()
	local type2=re:GetActiveType()-33
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp~=tp and Duel.IsChainNegatable(ev)
		and bit.band(type1,type2)~=0
end
function cm.rmfilter(c,tp,type2)
	return c:IsType(type2) and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local type2=re:GetActiveType()-33
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_MZONE,nil,tp,type2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local type2=re:GetActiveType()-33
	Duel.NegateActivation(ev)
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_MZONE,nil,tp,type2)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local type1=e:GetLabelObject():GetLabel()
	local tct=0
	if bit.band(type1,TYPE_RITUAL)~=0 then tct=tct+1 end
	if bit.band(type1,TYPE_FUSION)~=0 then tct=tct+1 end
	if bit.band(type1,TYPE_SYNCHRO)~=0 then tct=tct+1 end
	if bit.band(type1,TYPE_XYZ)~=0 then tct=tct+1 end
	if bit.band(type1,TYPE_LINK)~=0 then tct=tct+1 end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil,tp,POS_FACEDOWN)
	if chk==0 then return tct>0 and g:GetCount()>=tct end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,tct,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local type1=e:GetLabelObject():GetLabel()
	local tct=0
	if bit.band(type1,TYPE_RITUAL)~=0 then tct=tct+1 end
	if bit.band(type1,TYPE_FUSION)~=0 then tct=tct+1 end
	if bit.band(type1,TYPE_SYNCHRO)~=0 then tct=tct+1 end
	if bit.band(type1,TYPE_XYZ)~=0 then tct=tct+1 end
	if bit.band(type1,TYPE_LINK)~=0 then tct=tct+1 end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil,tp,POS_FACEDOWN)
	if tct==0 or g:GetCount()<tct then return end
	local sg=g:Select(tp,tct,tct,nil)
	Duel.HintSelection(sg)
	Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
	local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-ct*1000)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local type1=e:GetLabelObject():GetLabel()
	if bit.band(type1,TYPE_RITUAL)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
	end
	if bit.band(type1,TYPE_FUSION)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
	end
	if bit.band(type1,TYPE_SYNCHRO)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
	end
	if bit.band(type1,TYPE_XYZ)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
	end
	if bit.band(type1,TYPE_LINK)~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,4))
	end
end
