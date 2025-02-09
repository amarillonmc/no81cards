local m=4878159
local cm=_G["c"..m]
function cm.initial_effect(c)
aux.EnablePendulumAttribute(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(1163)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(cm.PendCondition())
	e1:SetOperation(cm.PendOperation())
	e1:SetValue(SUMMON_TYPE_RITUAL)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,0))
    e3:SetCategory(CATEGORY_DESTROY+CATEGORY_COUNTER)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_PZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(cm.ctcon)
    e3:SetTarget(cm.pentg)
    e3:SetOperation(cm.penop)
    c:RegisterEffect(e3)
	local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e6:SetRange(LOCATION_PZONE)
    e6:SetTarget(cm.splimit)
    e6:SetTargetRange(1,0)
    c:RegisterEffect(e6)
	local reg=0
	if reg==nil or reg then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(1160)
		e2:SetType(EFFECT_TYPE_ACTIVATE)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetRange(LOCATION_HAND)
		c:RegisterEffect(e2)
	end
		if not cm.PendulumChecklist then
		cm.PendulumChecklist=0
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(cm.PendulumReset)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.counterfilter(e,c,sump,sumtype,sumpos,targetp,se)
    return bit.band(sumtype,SUMMON_TYPE_PENDULUM)~=SUMMON_TYPE_PENDULUM
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetTargetRange(1,0)
    e1:SetTarget(cm.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function cm.penfilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_NORMAL)
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.penfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local g=Duel.SelectMatchingCard(tp,cm.penfilter,tp,LOCATION_DECK,0,1,1,nil)
        local tc=g:GetFirst()
        if tc then
            Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
        end
		 local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetTargetRange(1,0)
    e1:SetTarget(cm.splimit)
    Duel.RegisterEffect(e1,tp)
end
function cm.PendulumReset(e,tp,eg,ep,ev,re,r,rp)
	cm.PendulumChecklist=0
end
function cm.PConditionExtraFilterSpecific(c,e,tp,lscale,rscale,te)
	if not te then return true end
	local f=te:GetValue()
	return not f or f(te,c,e,tp,lscale,rscale)
end
function cm.PConditionExtraFilter(c,e,tp,lscale,rscale,eset)
	for _,te in ipairs(eset) do
		if cm.PConditionExtraFilterSpecific(c,e,tp,lscale,rscale,te) then return true end
	end
	return false
end
function cm.PConditionFilter1(c,e,tp,lscale,rscale,eset)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	local lv1=(lscale+rscale)/2
	local bool=cm.PendulumSummonableBool(c)
	return ((c:IsLocation(LOCATION_HAND) and c:IsType(TYPE_RITUAL)) or (c:IsFaceup() and c:IsType(TYPE_RITUAL)))
		and (lv<=lv1+1 and lv>=lv-1) 
		--lv==lv1 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,ture,true)
		and not c:IsForbidden()
		and (cm.PendulumChecklist&(0x1<<tp)==0 or cm.PConditionExtraFilter(c,e,tp,lscale,rscale,eset))
end
function cm.PConditionFilter(c,e,tp,lscale,rscale,eset)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	local lv1=(lscale+rscale)
	local bool=cm.PendulumSummonableBool(c)
	return ((c:IsLocation(LOCATION_HAND) and c:IsType(TYPE_RITUAL)) or (c:IsFaceup() and c:IsType(TYPE_RITUAL)))
		and lv<=lv1
		--lv==lv1 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,ture,true)
		and not c:IsForbidden()
		and (cm.PendulumChecklist&(0x1<<tp)==0 or cm.PConditionExtraFilter(c,e,tp,lscale,rscale,eset)) 
end
function cm.PendulumSummonableBool(c)
	return c.psummonable_location~=nil and c:GetLocation()&c.psummonable_location>0
end
function cm.PendCondition()
	return	function(e,c,og)
				if c==nil then return true end
				local tp=c:GetControler()
				local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
				if cm.PendulumChecklist&(0x1<<tp)~=0 and #eset==0 then return false end
				local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
				if rpz==nil or c==rpz then return false end
				local lscale=c:GetLeftScale()
				local rscale=rpz:GetRightScale()
				if lscale>rscale then lscale,rscale=rscale,lscale end
				local loc=0
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
				if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
				if loc==0 then return false end
				local g=nil
				if og then
					g=og:Filter(Card.IsLocation,nil,loc)
				else
					g=Duel.GetFieldGroup(tp,loc,0)
				end
				local lv1=lscale+rscale
				return g:IsExists(cm.PConditionFilter,1,nil,e,tp,lscale,rscale,eset)
				--g:IsExists(cm.PConditionFilter,1,nil,e,tp,lscale,rscale,eset,Card.GetLevel,"Greater")
				--g:IsExists(cm.PConditionFilter,1,nil,e,tp,lscale,rscale,eset)
				--g:CheckWithSumEqual(Card.GetLevel,lv1,1,99,e,tp,lscale,rscale,eset) 
			end
end
function cm.PendOperationCheck(ft1,ft2,ft)
	return	function(g)
				local exg=g:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
				local mg=g-exg
				return #g<=ft and #exg<=ft2 and #mg<=ft1
			end
end
function cm.PendOperation()
	return	function(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
				local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
				local lscale=c:GetLeftScale()
				local rscale=rpz:GetRightScale()
				if lscale>rscale then lscale,rscale=rscale,lscale end
				local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
				local tg=nil
				local lv1=lscale+rscale
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
				if ft1>0 then loc=loc|LOCATION_HAND end
				if ft2>0 then loc=loc|LOCATION_EXTRA end
				if og then
				--tg=og:Filter(Card.IsLocation,nil,loc):CheckWithSumEqual(Card.GetLevel,lv1,1,99,e,tp,lscale,rscale,eset) 
					tg=og:Filter(Card.IsLocation,nil,loc):Filter(cm.PConditionFilter,nil,e,tp,lscale,rscale,eset)
				else
				tg=Duel.GetMatchingGroup(cm.PConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale,eset)
					--tg=Duel.GetMatchingGroup(cm.PConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale,eset)
				end
				local ce=nil
				local b1=cm.PendulumChecklist&(0x1<<tp)==0
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
				--tg=tg:CheckWithSumEqual(Card.GetLevel,lv1,1,99,e,tp,lscale,rscale,ce) 
					tg=tg:Filter(cm.PConditionExtraFilterSpecific,nil,e,tp,lscale,rscale,ce)
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				aux.GCheckAdditional=cm.PendOperationCheck(ft1,ft2,ft)
				 --localg=tg:SelectSubGroup(tp,cm.RitualCheck,false,1,math.min(#tg,ft),tp,tc,tc:GetAttack(),"Greater")
			    --local g=tg:SelectWithSumEqual(tp,aux.TRUE,lv1,1,math.min(#tg,ft))
				local g=tg:SelectSubGroup(tp,cm.RitualCheckGreater,true,1,math.min(#tg,ft),tp,lv1)
				--local g=tg:SelectSubGroup(tp,aux.TRUE,true,1,math.min(#tg,ft))
				aux.GCheckAdditional=nil
				if not g then return end
				if ce then
					Duel.Hint(HINT_CARD,0,ce:GetOwner():GetOriginalCode())
					ce:UseCountLimit(tp)
				else
					cm.PendulumChecklist=cm.PendulumChecklist|(0x1<<tp)
				end
				sg:Merge(g)
				Duel.HintSelection(Group.FromCards(c))
				Duel.HintSelection(Group.FromCards(rpz))
					local dg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
					Duel.SendtoDeck(dg,nil,SEQ_DECKTOP,REASON_EFFECT)
					local og=Duel.GetOperatedGroup()
					local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
    if ct==0 then return end
    Duel.SortDecktop(tp,tp,ct)
			end
end
function cm.RitualCheckGreater(g,tp,lv1)
    Duel.SetSelectedCard(g)
    return --g:CheckWithSumGreater(Card.GetLevel,atk)
	 g:GetSum(Card.GetLevel)<=lv1
end