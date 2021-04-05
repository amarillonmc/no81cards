--珂拉琪的造物双子
local m=11451527
local cm=_G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	--face-up link
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(1166)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e3:SetCondition(cm.LinkCondition(nil,2,2,cm.lcheck))
	e3:SetTarget(aux.LinkTarget(nil,2,2,cm.lcheck))
	e3:SetOperation(aux.LinkOperation(nil,2,2,cm.lcheck))
	e3:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e3)
	--extra material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_PZONE,0)
	e0:SetValue(cm.matval)
	c:RegisterEffect(e0)
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
	c:RegisterEffect(e2)
	--setname
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_ADD_SETCODE)
	e5:SetRange(0xff)
	e5:SetValue(0x151)
	c:RegisterEffect(e5)
end
function cm.lcheck(g)
	return g:GetClassCount(Card.GetLinkRace)==1 and g:GetClassCount(Card.GetCode)==g:GetCount()
end
function cm.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,not mg or not mg:IsExists(Card.IsLocation,1,nil,LOCATION_PZONE)
end
function cm.LinkCondition(f,minc,maxc,gf)
	return  function(e,c,og,lmat,min,max)
				if c==nil then return true end
				if not (c:IsType(TYPE_PENDULUM) and c:IsFaceup()) then return false end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.LConditionFilter,nil,f,c)
				else
					mg=Auxiliary.GetLinkMaterials(tp,f,c)
				end
				if lmat~=nil then
					if not Auxiliary.LConditionFilter(lmat,f,c) then return false end
					mg:AddCard(lmat)
				end
				local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				return mg:CheckSubGroup(Auxiliary.LCheckGoal,minc,maxc,tp,c,gf,lmat)
			end
end
function cm.repfilter(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_PENDULUM) and ((c:GetLeaveFieldDest()==0 and c:IsLocation(LOCATION_ONFIELD) and c:GetDestination()==LOCATION_GRAVE) or (c:GetLeaveFieldDest()==0 and c:GetDestination()==LOCATION_EXTRA) or c:GetLeaveFieldDest()==LOCATION_EXTRA) and not c:IsLocation(LOCATION_PZONE)
end
function cm.seqfilter(c)
	return c:GetSequence()==0 or c:GetSequence()==4
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(cm.seqfilter,tp,LOCATION_SZONE,0,nil)
	local num=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then num=num+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then num=num+1 end
	if chk==0 then return (#Group.__band(tg,eg)>0 or num>0) and eg:IsExists(cm.repfilter,1,c,tp) end
	if Duel.GetFlagEffect(tp,m)~=0 or not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return false end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	local g=eg:Filter(cm.repfilter,c,tp)
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
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+m,e,fid,0,0,0)
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
	Duel.RaiseSingleEvent(c,EVENT_CUSTOM+m,e,fid,0,0,0)
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
		if not r or r~=c:GetFieldID() or ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL then return false end
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
		local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,loc,0,nil,0x97c)
		return g:IsExists(cm.PConditionFilter,1,nil,e,tp,lscale,rscale,nil)
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
	local tg=Duel.GetMatchingGroup(Card.IsSetCard,tp,loc,0,nil,0x97c)
	tg=tg:Filter(cm.PConditionFilter,nil,e,tp,lscale,rscale,nil)
	if #tg==0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=tg:SelectSubGroup(tp,aux.PendOperationCheck,false,1,1,ft1,ft2,ft)
	if not g then return end
	Duel.HintSelection(Group.FromCards(lpz))
	Duel.HintSelection(Group.FromCards(rpz))
	for tc in aux.Next(g) do
		local bool=aux.PendulumSummonableBool(tc)
		Duel.SpecialSummonStep(tc,SUMMON_TYPE_PENDULUM,tp,tp,bool,bool,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
	for tc in aux.Next(g) do tc:CompleteProcedure() end
end