--律法塔魂的最终魔王 法墨特
local m=79100330
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,c79100330.mfilter,c79100330.matfilter2,1,4,true)
	aux.EnableChangeCode(c,79100260,LOCATION_MZONE+LOCATION_GRAVE)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79100330,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCondition(c79100330.descon)
	e1:SetTarget(c79100330.destg)
	e1:SetOperation(c79100330.desop)
	c:RegisterEffect(e1)
	--destroy1
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(79100330,0))
	e11:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetRange(LOCATION_MZONE)
	e11:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e11:SetCondition(c79100330.descon1)
	e11:SetTarget(c79100330.destg1)
	e11:SetOperation(c79100330.desop)
	c:RegisterEffect(e11)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c79100330.discon)
	e2:SetOperation(c79100330.disop)
	c:RegisterEffect(e2)
	--material check	
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c79100330.matcon)
	e4:SetOperation(c79100330.matop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_MATERIAL_CHECK)
	e5:SetValue(c79100330.valcheck)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
end
function c79100330.mfilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_DARK) and c:IsFusionSetCard(0x3a11) and c:IsFusionType(TYPE_FUSION)
end
function c79100330.matfilter2(c)
	return c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_LIGHT)
end
function c79100330.adcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffectLabel(50221431) and e:GetHandler():GetFlagEffectLabel(50221431)>0
end
function c79100330.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and 
		c:GetFlagEffect(79100330)<c:GetFlagEffectLabel(50221431) end
	c:RegisterFlagEffect(79100330,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c79100330.descon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.GetTurnPlayer()==1-tp
		and e:GetHandler():GetFlagEffectLabel(79100331) and e:GetHandler():GetFlagEffectLabel(79100331)>2
end
function c79100330.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and c:GetFlagEffect(79100330)<c:GetFlagEffectLabel(79100331)-3 end
	c:RegisterFlagEffect(79100330,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c79100330.descon1(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.GetTurnPlayer()==tp
		and e:GetHandler():GetFlagEffectLabel(79100331) and e:GetHandler():GetFlagEffectLabel(79100331)>1
end
function c79100330.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and c:GetFlagEffect(79100330)<c:GetFlagEffectLabel(79100331)-2 end
	c:RegisterFlagEffect(79100330,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c79100330.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c79100330.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
	end
end
function c79100330.disfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c79100330.discon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local loc,pos=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_POSITION)
	local rc=re:GetHandler()
	return (loc==LOCATION_REMOVED and rc:IsControler(1-tp)) or 
		Duel.IsExistingMatchingCard(c79100330.disfilter,tp,0,LOCATION_REMOVED,1,nil,rc:GetCode())
end
function c79100330.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c79100330.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()>0
end
function c79100330.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(79100331,RESET_EVENT+RESETS_STANDARD,0,1,e:GetLabel())
end
function c79100330.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=g:GetCount()
	e:GetLabelObject():SetLabel(ct)
end