--时机龙骑·刻神指令
local m=40009205
local cm=_G["c"..m]
function cm.initial_effect(c)
	--proce
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddXyzProcedure(c,cm.matfilter,10,3) 
	--pendulum
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(cm.PendCondition())
	e1:SetOperation(cm.PendOperation())
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e1)
	--reg
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.xyzcon)
	e2:SetOperation(cm.xyzop)
	c:RegisterEffect(e2)  
	--place
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(cm.reg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.pcon)
	e4:SetTarget(cm.ptg)
	e4:SetOperation(cm.pop)
	c:RegisterEffect(e4)
end
function cm.xyzcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.xyzop(e,tp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,m)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(cm.negcon)
	e1:SetOperation(cm.negop)
	Duel.RegisterEffect(e1,tp)
end
function cm.matfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.PConditionExtraFilterSpecific(c,e,tp,nu1,nu2,te)
	if not te then return true end
	local f=te:GetValue()
	return not f or f(te,c,e,tp,nil,nil)
end
function cm.PConditionExtraFilter(c,e,tp,nu1,nu2,eset)
	for _,te in ipairs(eset) do
		if cm.PConditionExtraFilterSpecific(c,e,tp,nil,nil,te) then return true end
	end
	return false
end
function cm.PConditionFilter(c,e,tp,nu1,nu2,eset)
	local bool=Auxiliary.PendulumSummonableBool(c)
	return (c:IsLevelAbove(1) or c.pendulum_level) and c:IsSetCard(0x1f1c) and (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM))) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,bool,bool)
		and not c:IsForbidden()
		and (Auxiliary.PendulumChecklist&(0x1<<tp)==0 or cm.PConditionExtraFilter(c,e,tp,nil,nil,eset))
end
function cm.PendCondition()
	return  function(e,c,og)
				if c==nil then return true end
				local tp=c:GetControler()
				local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
				if Auxiliary.PendulumChecklist&(0x1<<tp)~=0 and #eset==0 then return false end
				local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
				if rpz==nil or c==rpz then return false end
				local loc=0
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND+LOCATION_REMOVED end
				if loc==0 then return false end
				local g=nil
				if og then
					g=og:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_REMOVED)
				else
					g=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_REMOVED,0)
				end
				return g:IsExists(cm.PConditionFilter,1,nil,e,tp,nil,nil,eset)
			end
end
function cm.PendOperation()
	return  function(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
				Duel.Hint(HINT_CARD,0,m)
				local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
				local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
				local tg=nil
				local loc=0
				local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
				local ft=Duel.GetUsableMZoneCount(tp)
				if Duel.IsPlayerAffectedByEffect(tp,59822133) then
					if ft1>0 then ft1=1 end
					ft=1
				end
				if ft1>0 then 
					loc=loc|LOCATION_HAND 
					loc=loc|LOCATION_REMOVED 
				end
				if og then
					tg=og:Filter(Card.IsLocation,nil,loc):Filter(cm.PConditionFilter,nil,e,tp,nil,nil,eset)
				else
					tg=Duel.GetMatchingGroup(cm.PConditionFilter,tp,loc,0,nil,e,tp,nil,nil,eset)
				end
				local ce=nil
				local b1=Auxiliary.PendulumChecklist&(0x1<<tp)==0
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
					tg=tg:Filter(cm.PConditionExtraFilterSpecific,nil,e,tp,nil,nil,ce)
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				Auxiliary.GCheckAdditional=Auxiliary.PendOperationCheck(ft1,0,ft)
				local g=tg:SelectSubGroup(tp,aux.TRUE,true,1,math.min(#tg,ft))
				Auxiliary.GCheckAdditional=nil
				if not g then return end
				if ce then
					Duel.Hint(HINT_CARD,0,ce:GetOwner():GetOriginalCode())
					ce:Reset()
				else
					Auxiliary.PendulumChecklist=Auxiliary.PendulumChecklist|(0x1<<tp)
				end
				sg:Merge(g)
				Duel.HintSelection(Group.FromCards(c))
				Duel.HintSelection(Group.FromCards(rpz))
			end
end
function cm.tdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1f1c) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_REMOVED,0,2,nil)
		and rp==1-tp and Duel.IsChainDisablable(ev) and aux.nbcon(tp,re)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(m,1)) then return end
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.HintSelection(tg)
	Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.reg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re and re:IsHasType(EFFECT_TYPE_ACTIONS) then
		c:RegisterFlagEffect(m+100,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.pcon(e,tp)
	return e:GetHandler():GetFlagEffect(m+100)>0
end
function cm.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x1f1c) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	if not Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then return end
	local sg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	if #sg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=sg:Select(tp,1,1,nil)
		Duel.BreakEffect()
		Duel.SpecialSummon(sg2,0,tp,tp,false,false,POS_FACEUP)
	end
end