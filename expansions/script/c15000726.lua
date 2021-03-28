local m=15000726
local cm=_G["c"..m]
cm.name="噩梦茧机·阿比盖尔"
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,true)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.psplimit)
	c:RegisterEffect(e1)
	--P Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,15000726)
	e2:SetCondition(cm.pcon)
	e2:SetTarget(cm.ptg)
	e2:SetOperation(cm.aop)
	c:RegisterEffect(e2)
	--switch and return
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetTarget(cm.swtg)
	e3:SetOperation(cm.swop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(cm.condition)
	c:RegisterEffect(e4)
	--P
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e5:SetRange(LOCATION_PZONE)
	e5:SetCode(EVENT_CUSTOM+15000726)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetOperation(cm.pop)  
	c:RegisterEffect(e5)
	--return
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e6:SetRange(LOCATION_PZONE)
	e6:SetCode(EVENT_CUSTOM+15000727)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetOperation(cm.dop)  
	c:RegisterEffect(e6)
end
function cm.psplimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_MACHINE) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function cm.cfilter(c)
	return c:IsSetCard(0x6f38)
end
function cm.pfilter(c)
	return c:IsSetCard(0x6f38)
end
function cm.sumfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function cm.PConditionFilter(c,e,tp,lscale,rscale,eset)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	local bool=Auxiliary.PendulumSummonableBool(c)
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,bool,bool)
		and not c:IsForbidden()
		and (PENDULUM_CHECKLIST&(0x1<<tp)==0 or Auxiliary.PConditionExtraFilter(c,e,tp,lscale,rscale,eset))
end
function cm.pcon(e,tp,eg,ep,ev,re,r,rp)
	if not PENDULUM_CHECKLIST then
		PENDULUM_CHECKLIST=0
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(Auxiliary.PendulumReset)
		Duel.RegisterEffect(ge1,0)
	end
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
	local pg=Duel.GetMatchingGroup(nil,tp,LOCATION_PZONE,0,nil)
	if pg:GetCount()~=2 then return false end
	local cc=pg:GetFirst()
	local lscale=cc:GetLeftScale()
	local dc=pg:GetNext()
	local rscale=dc:GetRightScale()
	if lscale>rscale then
		lscale=dc:GetRightScale()
		rscale=cc:GetLeftScale()
	end
	if (lscale==rscale or lscale==rscale-1 or lscale==rscale+1) then return false end
	local loc=0
	local sc=Duel.GetMatchingGroup(cm.sumfilter,tp,LOCATION_EXTRA,0,nil):GetFirst()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
	if sc and Duel.GetLocationCountFromEx(tp,tp,nil,sc)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return false end
	local g=nil
	if og then
		g=og:Filter(Card.IsLocation,nil,loc)
	else
		g=Duel.GetFieldGroup(tp,loc,0)
	end
	return g:IsExists(cm.PConditionFilter,1,nil,e,tp,lscale,rscale,eset) and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function cm.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
	local pg=Duel.GetMatchingGroup(nil,tp,LOCATION_PZONE,0,nil)
	if pg:GetCount()~=2 then return false end
	local cc=pg:GetFirst()
	local lscale=cc:GetLeftScale()
	local dc=pg:GetNext()
	local rscale=dc:GetRightScale()
	if lscale>rscale then
		lscale=dc:GetRightScale()
		rscale=cc:GetLeftScale()
	end
	local loc=0
	local sc=Duel.GetMatchingGroup(cm.sumfilter,tp,LOCATION_EXTRA,0,nil):GetFirst()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
	if sc and Duel.GetLocationCountFromEx(tp,tp,nil,sc)>0 then loc=loc+LOCATION_EXTRA end
	local g=nil
	if og then
		g=og:Filter(Card.IsLocation,nil,loc)
	else
		g=Duel.GetFieldGroup(tp,loc,0)
	end
	local yg=g:Filter(cm.PConditionFilter,nil,e,tp,lscale,rscale,eset)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,yg,yg:GetCount(),tp,0)
end
function cm.aop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+15000726,re,r,rp,ep,ev)
end
function cm.pop(e,tp,eg,ep,ev,re,r,rp,sg,og)
	if not PENDULUM_CHECKLIST then
		PENDULUM_CHECKLIST=0
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(Auxiliary.PendulumReset)
		Duel.RegisterEffect(ge1,0)
	end
	local pg=Duel.GetMatchingGroup(nil,tp,LOCATION_PZONE,0,nil)
	if pg:GetCount()~=2 then return end
	local cc=pg:GetFirst()
	local lscale=cc:GetLeftScale()
	local dc=pg:GetNext()
	local rscale=dc:GetRightScale()
	if lscale>rscale then
		lscale=dc:GetRightScale()
		rscale=cc:GetLeftScale()
	end
	if (lscale==rscale or lscale==rscale-1 or lscale==rscale+1) then return end
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
	local tg=nil
	local loc=0
	local sc=Duel.GetMatchingGroup(cm.sumfilter,tp,LOCATION_EXTRA,0,nil):GetFirst()
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=0
	if sc then
		ft2=Duel.GetLocationCountFromEx(tp,tp,nil,sc)
	end
	local ft=Duel.GetUsableMZoneCount(tp)
	local ect=99
	if c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) then
		ect=c29724053[tp]
	end
	if ect and ect<ft2 then ft2=ect end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
			ft=1
	end
	if ft1>0 then loc=loc|LOCATION_HAND end
	if ft2>0 then loc=loc|LOCATION_EXTRA end
	if og then
		tg=og:Filter(Card.IsLocation,nil,loc):Filter(cm.PConditionFilter,nil,e,tp,lscale,rscale,eset)
	else
		tg=Duel.GetMatchingGroup(cm.PConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale,eset)
	end
	local ce=nil
	local b1=PENDULUM_CHECKLIST&(0x1<<tp)==0
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
	Auxiliary.GCheckAdditional=Auxiliary.PendOperationCheck(ft1,ft2,ft)
	local g=tg:SelectSubGroup(tp,aux.TRUE,true,1,math.min(#tg,ft))
	Auxiliary.GCheckAdditional=nil
	if not g then return end
	if ce then
		Duel.Hint(HINT_CARD,0,ce:GetOwner():GetOriginalCode())
		ce:Reset()
	end
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	Duel.HintSelection(Group.FromCards(lpz))
	Duel.HintSelection(Group.FromCards(rpz))
	local spg=Group.CreateGroup()
	for tc in aux.Next(g) do
		local bool=aux.PendulumSummonableBool(tc)
		if Duel.SpecialSummonStep(tc,SUMMON_TYPE_PENDULUM,tp,tp,bool,bool,POS_FACEUP) then spg:AddCard(tc) end
	end
	Duel.SpecialSummonComplete()
	for tc in aux.Next(g) do tc:CompleteProcedure() end
	if spg:GetCount()~=0 then
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+15000727,re,r,rp,ep,ev)
	end
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsAbleToHand() then Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT) end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function cm.swfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetAttack()~=c:GetDefense()
end
function cm.swtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.swfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.swfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.swfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function cm.swop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(def)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(atk)
		tc:RegisterEffect(e2)
		if tc:GetOverlayCount()~=0 and tc:GetOverlayGroup():IsExists(Card.IsAbleToHand,1,nil) then
			local ag=tc:GetOverlayGroup():FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
			Duel.SendtoHand(ag,nil,REASON_EFFECT)
		end
	end
end