local m=15000583
local cm=_G["c"..m]
cm.name="罪 绝对自由龙"
function cm.initial_effect(c)
	aux.AddCodeList(c,27564031)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x23),1,1)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,1,15000583)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCondition(cm.sprcon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_REMOVE)
	e3:SetOperation(cm.regop)
	c:RegisterEffect(e3)
	--exc
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCondition(cm.sp2con)
	e4:SetTarget(cm.sp2tg)
	e4:SetOperation(cm.sp2op)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,m)
	e5:SetTarget(cm.target)
	e5:SetOperation(cm.activate)
	c:RegisterEffect(e5)
	--selfdes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_SELF_DESTROY)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(cm.descon)
	c:RegisterEffect(e6)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetOperation(cm.reg2op)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.descon(e)
	return not Duel.IsEnvironment(27564031)
end
function cm.reg2filter(c)
	return c:IsReason(REASON_SPSUMMON) and c:GetReasonEffect():GetHandler():IsSetCard(0x23) and c:IsLocation(LOCATION_REMOVED)
end
function cm.reg2op(e,tp,eg,ep,ev,re,r,rp)
	local og=eg:Filter(cm.reg2filter,nil)
	local oc=og:GetFirst()
	while oc do
		oc:RegisterFlagEffect(m+2,RESET_EVENT+RESETS_STANDARD,0,1)
		oc=og:GetNext()
	end
end
function cm.sprcon(e,c)
	if c==nil then return true end
	return c:GetFlagEffect(m)~=0
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.sprfilter(c,tp)
	return c:IsSetCard(0x23) and c:IsLevel(10) and Duel.GetMZoneCount(tp,c)>0 and (c:IsControler(tp) or c:IsFaceup())
end
function cm.sp2con(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(m+1)~=0
end
function cm.sp2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(cm.sprfilter,nil,tp)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		e:SetLabel(1)
	else
		e:SetLabel(2)
	end
end
function cm.sp2op(e,tp,eg,ep,ev,re,r,rp)
	local t=e:GetLabel()
	if t and t==2 then return end
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
	local c=e:GetHandler()
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
	--
	Duel.SpecialSummonRule(tp,c)
	--
	c:ResetFlagEffect(m)
end
function cm.filter(c,e,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,c:GetCode(),e,tp) and c:GetFlagEffect(m+2)~=0
end
function cm.filter2(c,code,e,tp)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and (c:IsLocation(LOCATION_DECK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,tc:GetCode(),e,tp)
	local sc=sg:GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)
	end
end