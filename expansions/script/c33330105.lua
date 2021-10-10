--造神计划5 空想原核
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(33330105)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMixRep(c,true,true,cm.ffilter,3,3,cm.ffilter2,cm.ffilter2)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_GRAVE,LOCATION_GRAVE,Duel.Remove,POS_FACEUP,REASON_COST)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(cm.splimit)
	c:RegisterEffect(e0)
	local e1=rsef.FC(c,EVENT_CHAINING)
	e1:SetCondition(cm.rmcon)
	e1:SetOperation(cm.rmop)
	local e2=rsef.QO(c,nil,{m,0},nil,"td",nil,LOCATION_MZONE,rscon.phase("mp1","mp2","bp"),cm.cost,rsop.target(rscf.FilterFaceUp(Card.IsAbleToDeck),"td",LOCATION_REMOVED,LOCATION_REMOVED),cm.tdop)
	local e3=rsef.STO(c,EVENT_LEAVE_FIELD,{m,1},{1,m},"sp","de,dsp",cm.spcon,nil,rsop.target(cm.spfilter,"sp",LOCATION_GRAVE,0,1,1,c),cm.spop)
end
function cm.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function cm.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionType(TYPE_FUSION) and (not sg or (not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()) and sg:IsExists(Card.IsFusionSetCard,1,nil,0x551))) 
end
function cm.ffilter2(c,fc,sub,mg,sg)
	return c:IsFusionType(TYPE_LINK) and c:IsLinkAbove(2) and (not sg or sg:IsExists(Card.IsFusionSetCard,1,nil,0x551)) 
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return loc&LOCATION_ONFIELD+LOCATION_HAND ~=0 and re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsAbleToRemove()
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	Duel.Hint(HINT_CARD,0,m)
	local reason=rc:IsType(TYPE_MONSTER) and REASON_TEMPORARY+REASON_EFFECT or REASON_EFFECT 
	if Duel.Remove(rc,POS_FACEUP,reason)<=0 then return end
	rc:RegisterFlagEffect(m,rsreset.est,0,1,ev)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCountLimit(1)
	e1:SetLabel(ev)
	e1:SetLabelObject(rc)
	e1:SetCondition(cm.retcon1)
	e1:SetOperation(cm.retop1)
	Duel.RegisterEffect(e1,tp)
end
function cm.retcon1(e,tp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(m)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function cm.retop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc:IsReason(REASON_TEMPORARY) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
	if tc:IsPreviousLocation(LOCATION_HAND) then Duel.SendtoHand(tc,nil,REASON_EFFECT) end
	if tc:IsPreviousLocation(LOCATION_MZONE) then Duel.ReturnToField(tc) end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetDescription(aux.Stringid(m,2))
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetCurrentPhase())
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCondition(cm.retcon2)
		e1:SetOperation(cm.retop2)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.retcon2(e,tp)
	return Duel.GetCurrentPhase()~=e:GetLabel()
end
function cm.retop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function cm.tdop(e,tp)
	local c=e:GetHandler()
	local ct,og=rsop.SelectToDeck(tp,rscf.FilterFaceUp(Card.IsAbleToDeck),tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,{})
	if ct<=0 then return end
	local tc=og:GetFirst()
	if not tc:IsLocation(LOCATION_EXTRA+LOCATION_DECK) then return false end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(cm.distg)
	e1:SetLabelObject(tc)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(cm.discon)
	e2:SetOperation(cm.disop)
	e2:SetLabelObject(tc)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
end
function cm.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsCode(tc:GetOriginalCodeRule())
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsCode(tc:GetOriginalCodeRule())
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function cm.spcon(e,tp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function cm.spfilter(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsSetCard(0x551) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spop(e,tp)
	local ct,og=rsop.SelectSpecialSummon(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,aux.ExceptThisCard(e),{0,tp,tp,false,false,POS_FACEUP_DEFENSE,nil,{"dis,dise",true},"des" },e,tp)
end