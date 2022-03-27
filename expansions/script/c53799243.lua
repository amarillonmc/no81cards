local m=53799243
local cm=_G["c"..m]
cm.name="伤员护送"
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(cm.effop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC_G)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.PendCondition)
	e2:SetOperation(cm.PendOperation)
	e2:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e2)
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(function(c,lg,ignore_flag)return c:IsType(TYPE_PENDULUM) and (ignore_flag or c:GetFlagEffect(m)==0)end,tp,LOCATION_PZONE,0,c)
	if c:IsDisabled() then return end
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(m,RESET_EVENT+0x1fe1000,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,0))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC_G)
		e1:SetRange(LOCATION_PZONE)
		e1:SetLabelObject(c)
		e1:SetCost(cm.pencost)
		e1:SetCondition(cm.PendCondition)
		e1:SetOperation(cm.PendOperation)
		e1:SetValue(SUMMON_TYPE_PENDULUM)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function cm.pencost(e,tp,eg,ep,ev,re,r,rp)
	local gc=e:GetLabelObject()
	if chk==0 then return gc and not gc:IsDisabled() and gc:IsLocation(LOCATION_SZONE) end
end
function cm.PConditionFilter(c,e,tp,lscale,rscale,eset)
	local lv=0
	if c.pendulum_level then lv=c.pendulum_level else lv=c:GetLevel() end
	local bool=aux.PendulumSummonableBool(c)
	return ((c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE)) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,bool,bool)
		and not c:IsForbidden()
		and (aux.PendulumChecklist&(0x1<<tp)==0 or aux.PConditionExtraFilter(c,e,tp,lscale,rscale,eset))
end
function cm.PendCondition(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
	if aux.PendulumChecklist&(0x1<<tp)~=0 and #eset==0 then return false end
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if rpz==nil or c==rpz then return false end
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND+LOCATION_GRAVE end
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return false end
	local g=nil
	if og then
		g=og:Filter(Card.IsLocation,nil,loc)
	else
		g=Duel.GetFieldGroup(tp,loc,0)
	end
	return g:IsExists(cm.PConditionFilter,1,nil,e,tp,lscale,rscale,eset) 
end
function cm.PendOperationCheck(ft1,ft2,ft)
	return  function(g)
				local exg=g:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
				local gxg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
				local mg=g-exg
				return #g<=ft and #exg<=ft2 and #mg<=ft1 and #gxg<=1
			end
end
function cm.PendOperation(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
	local tg=nil
	local loc=0
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
	local ft=Duel.GetUsableMZoneCount(tp)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect and ect<ft2 then ft2=ect end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		ft=1
	end
	if ft1>0 then loc=loc|LOCATION_HAND|LOCATION_GRAVE end
	if ft2>0 then loc=loc|LOCATION_EXTRA end
	if og then
		tg=og:Filter(Card.IsLocation,nil,loc):Filter(cm.PConditionFilter,nil,e,tp,lscale,rscale,eset)
	else
		tg=Duel.GetMatchingGroup(cm.PConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale,eset)
	end
	local ce=nil
	local b1=aux.PendulumChecklist&(0x1<<tp)==0
	local b2=#eset>0
	if b1 and b2 then
		local options={1163}
		for _,te in ipairs(eset) do
			table.insert(options,te:GetDescription())
		end
		local op=Duel.SelectOption(tp,table.unpack(options))
		if op>0 then
			ce=eset[op]
		end
	elseif b2 and not b1 then
		local options={}
		for _,te in ipairs(eset) do
			table.insert(options,te:GetDescription())
		end
		local op=Duel.SelectOption(tp,table.unpack(options))
		ce=eset[op+1]
	end
	if ce then
		tg=tg:Filter(aux.PConditionExtraFilterSpecific,nil,e,tp,lscale,rscale,ce)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.GCheckAdditional=cm.PendOperationCheck(ft1,ft2,ft)
	local g=tg:SelectSubGroup(tp,aux.TRUE,true,1,math.min(#tg,ft))
	aux.GCheckAdditional=nil
	if not g then return end
	if ce then
		Duel.Hint(HINT_CARD,0,ce:GetOwner():GetOriginalCode())
		ce:Reset()
	else
		aux.PendulumChecklist=aux.PendulumChecklist|(0x1<<tp)
	end
	sg:Merge(g)
	Duel.HintSelection(Group.FromCards(c))
	Duel.HintSelection(Group.FromCards(rpz))
end
