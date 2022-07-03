--双天法 那罗延
--21.09.12
local m=11451626
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion
	c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,cm.matfilter,aux.FilterBoolFunction(Card.IsFusionSetCard,0x14f),2,true,true)
	--effect monster material check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(cm.matcheck)
	c:RegisterEffect(e0)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetCondition(cm.imcon)
	e1:SetValue(cm.imval)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.descon)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e3:SetLabelObject(g)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(cm.descon2)
	e4:SetOperation(cm.desop2)
	c:RegisterEffect(e4)
	e4:SetLabelObject(g)
end
function cm.matfilter(c)
	return c:IsFusionSetCard(0x14f) and c:IsType(TYPE_FUSION)
end
function cm.matcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,1,nil,TYPE_EFFECT) then
		c:RegisterFlagEffect(85360035,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
	end
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function cm.imcon(e)
	return Duel.IsExistingMatchingCard(cm.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,nil)
end
function cm.imval(e,te)
	if te:GetHandlerPlayer()==e:GetHandlerPlayer() then return false end
	if not te:IsActivated() then return true end
	local lab=e:GetHandler():GetFlagEffectLabel(m)
	local ev=Duel.GetChainInfo(0,CHAININFO_CHAIN_COUNT)
	return ev and ev>0 and not (lab and lab==ev+1)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.desfilter(c,e,tp,bool)
	return c:IsFaceup() and c:IsSetCard(0x14f) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,bool)
end
function cm.spfilter(c,e,tp,tc,bool)
	local f=cm.spfilter2
	if bool then f=aux.NecroValleyFilter(f) end
	return c:IsSetCard(0x14f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>1 and Duel.IsExistingMatchingCard(f,tp,LOCATION_GRAVE,0,1,nil,e,tp,c,tc)
end
function cm.spfilter2(c,e,tp,mc,tc)
	return c:IsSetCard(0x14f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp,tc)>0 and math.abs(c:GetOriginalLevel()-mc:GetOriginalLevel())==1
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,false) and e:GetHandler():GetFlagEffect(m)==0 and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1,Duel.GetCurrentChain())
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_MZONE,0,nil,e,tp,false)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,true)
	if g and Duel.Destroy(g,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil,true)
		local mc=g1:GetFirst()
		local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter2),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,mc,nil)
		g1:Merge(g2)
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return e:GetHandler():GetFlagEffect(m)==0 end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1,Duel.GetCurrentChain())
	if Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local tc=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
		c:SetCardTarget(tc)
		e:GetLabelObject():AddCard(tc)
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:GetHandler():RegisterFlagEffect(m-1,RESET_EVENT+RESETS_STANDARD,0,1)
end
function cm.desfilter2(c,e)
	return c:IsOnField() and e:GetHandler():IsHasCardTarget(c)
end
function cm.descon2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	return g:IsExists(cm.desfilter2,1,nil,e) and e:GetHandler():GetFlagEffect(m-1)>0
end
function cm.desop2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(cm.desfilter2,nil,e)
	Duel.Destroy(tg,REASON_EFFECT)
end