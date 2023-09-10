--珂拉琪残像 拼贴
local cm,m=GetID()
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--replace
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetTarget(cm.reptg)
	e1:SetValue(cm.repval)
	c:RegisterEffect(e1)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e1:SetLabelObject(g)
	--extra pendulum
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+m)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(cm.psptg)
	e2:SetOperation(cm.pspop)
	--c:RegisterEffect(e2)
	--only
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.repfilter(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_PENDULUM) and ((c:GetLeaveFieldDest()==0 and c:IsLocation(LOCATION_ONFIELD) and c:GetDestination()==LOCATION_GRAVE) or (c:GetLeaveFieldDest()==0 and c:GetDestination()==LOCATION_EXTRA) or c:GetLeaveFieldDest()==LOCATION_EXTRA) and not c:IsLocation(LOCATION_PZONE)
end
function cm.seqfilter(c)
	return c:GetSequence()==0 or c:GetSequence()==4
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(cm.seqfilter,tp,LOCATION_SZONE,0,nil,tp)
	local num=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then num=num+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then num=num+1 end
	if chk==0 then return (#Group.__band(tg,eg)>0 or num>0) and eg:IsExists(cm.repfilter,1,c,tp) end
	local g=eg:Filter(cm.repfilter,c,tp)
	if Duel.GetFlagEffect(tp,m)~=0 then return false end
	if g:IsExists(Card.IsOnField,1,nil) then Duel.HintSelection(g) end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return false end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		g=g:Select(tp,1,#Group.__band(tg,eg)+num,nil)
	end
	local tc=g:GetFirst()
	local container=e:GetLabelObject()
	container:Clear()
	container:Merge(g)
	local fid=c:GetFieldID()
	if #g>num then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_MOVE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(container)
		e1:SetOperation(cm.adjustop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	else
		for tc in aux.Next(g) do
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
		local e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e2:SetCode(EVENT_CUSTOM+m)
		e2:SetLabel(fid)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetTarget(cm.psptg)
		e2:SetOperation(cm.pspop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		Duel.RaiseEvent(c,EVENT_CUSTOM+m,e,fid,0,0,0)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	return true
end
function cm.repval(e,c)
	return e:GetLabelObject():IsContains(c)
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=e:GetLabel()
	local g=e:GetLabelObject()
	for tc in aux.Next(g) do
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+m)
	e2:SetLabel(fid)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(cm.psptg)
	e2:SetOperation(cm.pspop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	Duel.RaiseEvent(c,EVENT_CUSTOM+m,e,fid,0,0,0)
end
function cm.PConditionFilter(c,e,tp,lscale,rscale,eset)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	local bool=aux.PendulumSummonableBool(c)
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM))) and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,bool,bool) and not c:IsForbidden()
end
function cm.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local ph=Duel.GetCurrentPhase()
		if not r or r~=e:GetLabel() or ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL then return false end
		local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
		local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
		if rpz==nil or lpz==nil then return false end
		local lscale=lpz:GetLeftScale()
		local rscale=rpz:GetRightScale()
		if lscale>rscale then lscale,rscale=rscale,lscale end
		local loc=0
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
		if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
		if loc==0 then return false end
		local g=Duel.GetMatchingGroup(nil,tp,loc,0,nil)
		local _PendulumChecklist=aux.PendulumChecklist
		aux.PendulumChecklist=0
		local res=g:IsExists(aux.PConditionFilter,1,nil,e,tp,lscale,rscale,nil)
		aux.PendulumChecklist=_PendulumChecklist
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.pspop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if rpz==nil or lpz==nil then return false end
	local lscale=lpz:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local loc=0
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp)
	local ft=Duel.GetUsableMZoneCount(tp)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect and ect<ft2 then ft2=ect end
	if ft1>0 then loc=loc|LOCATION_HAND end
	if ft2>0 then loc=loc|LOCATION_EXTRA end
	if loc==0 then return false end
	local tg=Duel.GetMatchingGroup(nil,tp,loc,0,nil)
	local _PendulumChecklist=aux.PendulumChecklist
	aux.PendulumChecklist=0
	tg=tg:Filter(aux.PConditionFilter,nil,e,tp,lscale,rscale,nil)
	aux.PendulumChecklist=_PendulumChecklist
	if #tg==0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.GCheckAdditional=Auxiliary.PendOperationCheck(ft1,ft2,ft)
	local g=tg:SelectSubGroup(tp,aux.TRUE,true,1,1)
	aux.GCheckAdditional=nil
	if not g then return end
	Duel.HintSelection(Group.FromCards(lpz))
	Duel.HintSelection(Group.FromCards(rpz))
	--[[for tc in aux.Next(g) do
		local bool=aux.PendulumSummonableBool(tc)
		Duel.SpecialSummonStep(tc,SUMMON_TYPE_PENDULUM,tp,tp,bool,bool,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
	for tc in aux.Next(g) do tc:CompleteProcedure() end--]]
	local tc=g:GetFirst()
	if not tc.pendulum_rule then
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_HAND+LOCATION_EXTRA)
		e1:SetLabel(1)
		e1:SetCondition(function(e) return e:GetLabel()==1 end)
		e1:SetTarget(function(e) e:SetLabel(0) return true end)
		e1:SetValue(SUMMON_TYPE_PENDULUM)
		tc:RegisterEffect(e1,true)
		_G["c"..tc:GetOriginalCode()].pendulum_rule=e1
	else
		tc.pendulum_rule:SetLabel(1)
	end
	Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_PENDULUM)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:GetCount()==1 and eg:GetFirst()==c and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function cm.matfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,1,nil,mg)
	local tc=g:GetFirst()
	if tc then Duel.LinkSummon(tp,tc,mg) end
end