local m=25000077
local cm=_G["c"..m]
cm.name="CONCEPT-X6-1-2 逆X"
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,nil,9,4)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(function(e,se,sp,st)return aux.xyzlimit(e,se,sp,st) or not e:GetHandler():IsLocation(LOCATION_EXTRA)end)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.cpcon)
	e3:SetCost(cm.cpcost)
	e3:SetTarget(cm.cptg)
	e3:SetOperation(cm.cpop)
	c:RegisterEffect(e3)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) then return end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetOverlayGroup():Filter(cm.spfilter,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g>0 and Duel.GetFlagEffect(tp,m)==0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_OVERLAY)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=e:GetHandler():GetOverlayGroup():Filter(cm.spfilter,nil,e,tp)
	if ct<=0 or g:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	g=g:Select(tp,ct,ct,nil)
	local fid=e:GetHandler():GetFieldID()
	local sg=Group.CreateGroup()
	e:GetHandler():RegisterFlagEffect(m+10000,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	for tc in aux.Next(g) do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		sg:AddCard(tc)
	end
	Duel.SpecialSummonComplete()
	sg:KeepAlive()
	sg:AddCard(e:GetHandler())
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.descon)
	e1:SetOperation(cm.desop)
	e1:SetLabel(fid)
	e1:SetLabelObject(sg)
	Duel.RegisterEffect(e1,tp)
end
function cm.desfilter(c,fid)
	return c:GetFlagEffectLabel(m)==fid 
end
function cm.matfilter(c,fid)
	return c:GetFlagEffectLabel(m+10000)==fid 
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(cm.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	local cc=e:GetLabelObject():Filter(cm.matfilter,nil,e:GetLabel()):GetFirst()
	local dg=sg:Filter(cm.desfilter,nil,e:GetLabel())
	sg:DeleteGroup()
	if dg:GetCount()>0 and cc then
		Duel.Overlay(cc,dg)
	end
end
function cm.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and cm.ProtectedRun(tg,e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	local te=re:Clone()
	local tg=te:GetTarget()
	local code=te:GetCode()
	local tres,teg,tep,tev,tre,tr,trp
	if code>0 and code~=EVENT_FREE_CHAIN and code~=EVENT_CHAINING and Duel.CheckEvent(code) then
		tres,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(code,true)
	end
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		local res=false
		if not tg then return true end
		if tres then return cm.ProtectedRun(tg,e,tp,teg,tep,tev,tre,tr,trp,0)
		else return cm.ProtectedRun(tg,e,tp,eg,ep,ev,re,r,rp,0) end
	end
	e:SetLabel(te:GetLabel())
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	if tg then
		if tres then
			cm.ProtectedRun(tg,e,tp,teg,tep,tev,tre,tr,trp,1)
		else
			cm.ProtectedRun(tg,e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	local ex=Effect.GlobalEffect()
	ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ex:SetCode(EVENT_CHAIN_END)
	ex:SetLabelObject(e)
	ex:SetOperation(function(e)
		e:GetLabelObject():SetLabel(0)
		ex:Reset()
	end)
	Duel.RegisterEffect(ex,tp)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if te:IsHasType(EFFECT_TYPE_ACTIVATE) then
		e:GetHandler():ReleaseEffectRelation(e)
	end
	cm.ProtectedRun(op,e,tp,eg,ep,ev,re,r,rp)
end
function cm.ProtectedRun(f,...)
	if not f then return true end
	local params={...}
	local ret={}
	local res_test=pcall(function()
		ret={f(table.unpack(params))}
	end)
	if not res_test then return false end
	return table.unpack(ret)
end
