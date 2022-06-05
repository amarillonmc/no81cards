local m=53799105
local cm=_G["c"..m]
cm.name="奈芙提斯之合凰神"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionType,TYPE_RITUAL),function(c)return c:IsRace(RACE_WINDBEAST) and c:IsLevel(8)end,true)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.con)
	e0:SetOperation(cm.op)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(function(e,se,sp,st)return not e:GetHandler():IsLocation(LOCATION_EXTRA)end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CUSTOM+m)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m+500)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.count)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(cm.reset)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge3:SetOperation(cm.seteg)
		Duel.RegisterEffect(ge3,0)
	end
end
function cm.count(e,tp,eg,ep,ev,re,r,rp)
	cm.chain=true
end
function cm.seteg(e,tp,eg,ep,ev,re,r,rp)
	if cm.chain==true then
		local g=Group.CreateGroup()
		if cm[0] then g=cm[0] end
		g:Merge(eg)
		g:KeepAlive()
		cm[0]=g
	end
	if cm.chain==false then
		Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,r,rp,ep,ev)
	end
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	cm.chain=false
	if not cm[0] then return end
	Duel.RaiseEvent(cm[0],EVENT_CUSTOM+m,re,r,rp,ep,ev)
	cm[0]=nil
end
function cm.filter(c,fc)
	return c:IsCanBeFusionMaterial(fc,SUMMON_TYPE_SPECIAL) and c:IsAbleToGraveAsCost()
end
function cm.con(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil,c)
	return c:CheckFusionMaterial(mg,nil,tp|0x200)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil,c)
	local g=Duel.SelectFusionMaterial(tp,c,mg,nil,tp|0x200)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_DESTROY+REASON_EFFECT)
	--for tc in aux.Next(g) do Duel.RaiseSingleEvent(tc,EVENT_DESTROYED,e,REASON_EFFECT,tp,tp,0) end
	--Duel.RaiseEvent(g,EVENT_DESTROYED,e,REASON_EFFECT,tp,tp,0)
end
function cm.spfilter(c,typ,e,tp,tc)
	return ((typ&TYPE_MONSTER~=0 and c:IsCode(24175232)) or (typ&(TYPE_SPELL+TYPE_TRAP)~=0 and c:IsCode(61441708))) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and Duel.GetMZoneCount(tp,tc)
end
function cm.desfilter(c,e,tp)
	return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,c:GetType(),e,tp,c)
end
function cm.chkfilter(c,typ)
	return c:IsFaceup() and c:IsSetCard(0x8) and (c:GetType()&typ)==typ
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and cm.chkfilter(chkc,e:GetLabel()) end
	if chk==0 then return Duel.IsExistingTarget(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	e:SetLabel(g:GetFirst():GetType())
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,tc:GetType(),e,tp,nil):GetFirst()
		if not sc then return end
		sc:SetMaterial(nil)
		if Duel.SpecialSummon(sc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)==0 then return end
		local fid=e:GetHandler():GetFieldID()
		sc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid)
		e1:SetLabelObject(sc)
		e1:SetCondition(cm.sdcon)
		e1:SetOperation(cm.sdop)
		Duel.RegisterEffect(e1,tp)
		sc:CompleteProcedure()
	end
end
function cm.sdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(m)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function cm.sdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
function cm.dfilter(c)
	return c:IsSummonLocation(LOCATION_GRAVE) and c:IsLocation(LOCATION_MZONE)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(cm.dfilter,nil)
	if chk==0 then return #g>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp,g)>0 end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.dfilter,nil):Filter(Card.IsRelateToEffect,nil,e)
	local c=e:GetHandler()
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
end
