--青之汐雏 雾雨之游
local cm,m=GetID()
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--extra pendulum
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e1:SetCondition(cm.pspcon)
	e1:SetTarget(cm.psptg)
	e1:SetOperation(cm.pspop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCost(cm.pspcost)
	--c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCondition(cm.effcon)
	e4:SetOperation(cm.regop)
	c:RegisterEffect(e4)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.pspcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetActivateLocation()==LOCATION_HAND or re:GetHandler():IsStatus(STATUS_ACT_FROM_HAND)
end
function cm.pspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if c:GetFlagEffect(m+1)>0 then return false end
		for i=1,Duel.GetCurrentChain() do
			local te,tep,loc,pos=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_POSITION)
			if te:IsHasType(EFFECT_TYPE_QUICK_F) or te:IsHasType(EFFECT_TYPE_QUICK_O) or te:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
			if te:IsHasType(EFFECT_TYPE_TRIGGER_O) and loc==LOCATION_HAND and pos&POS_FACEDOWN>0 then return false end
			if te:IsHasType(EFFECT_TYPE_TRIGGER_O) and tep==1-tp and Duel.GetTurnPlayer()==tp then return false end
		end
		return true
	end
end
function cm.dfilter(c,lv)
	return c:IsType(TYPE_PENDULUM) and c:GetLeftScale()<lv
end
function cm.hfilter(c,lv)
	return c:IsType(TYPE_PENDULUM) and c:GetLeftScale()>lv
end
function cm.fselect(g,lv)
	return g:IsExists(cm.dfilter,1,nil,lv) and g:IsExists(cm.hfilter,1,nil,lv) and g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1 and g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=1
end
function cm.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if chk==0 then
		if c:IsLocation(LOCATION_EXTRA) and c:GetFlagEffect(m)>0 then return false end
		if Duel.GetFlagEffect(tp,m)==0 then
			Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(m,5))
			Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
		end
		--if (e:IsHasType(EFFECT_TYPE_TRIGGER_O) and c:IsFaceup()) or (e:IsHasType(EFFECT_TYPE_QUICK_O) and c:IsFacedown()) then return false end
		if Duel.GetCurrentChain()<1 then return false end
		if c:GetFlagEffect(m+1)>0 then return false end
		local loc=0
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
		if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
		if loc==0 or not c:IsLocation(loc) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false) then return false end
		if rpz==nil and lpz==nil then
			local z1=Duel.CheckLocation(tp,LOCATION_SZONE,0)
			local z2=Duel.CheckLocation(tp,LOCATION_SZONE,4)
			if not z1 or not z2 then return false end
			local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,c,TYPE_PENDULUM)
			if Duel.GetCurrentChain()>0 then
				g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,c,TYPE_PENDULUM)
			end
			local res=g:CheckSubGroup(cm.fselect,2,2,lv)
			--if res then c:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1) end
			return res
		elseif rpz==nil or lpz==nil then
			local seq=0
			if lpz then seq=4 end
			local z1=Duel.CheckLocation(tp,LOCATION_SZONE,seq)
			if not z1 then return false end
			local pz=lpz or rpz
			local scale=pz:GetLeftScale()
			local ds=lv<scale
			local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,c,TYPE_PENDULUM)
			local fil=cm.dfilter
			if lv>scale then fil=cm.hfilter end
			if Duel.GetCurrentChain()>0 then
				g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,c,TYPE_PENDULUM)
			end
			local res=g:IsExists(fil,1,nil,lv)
			--if res then c:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1) end
			return res
		else
			local lscale=lpz:GetLeftScale()
			local rscale=rpz:GetRightScale()
			if lscale>rscale then lscale,rscale=rscale,lscale end
			local res=lv>lscale and lv<rscale
			--if res then c:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1) end
			return res
		end
	end
	c:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	local sg=Group.CreateGroup()
	if rpz==nil and lpz==nil then
		local z1=Duel.CheckLocation(tp,LOCATION_SZONE,0)
		local z2=Duel.CheckLocation(tp,LOCATION_SZONE,4)
		if not z1 or not z2 then return false end
		local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,c,TYPE_PENDULUM)
		if Duel.GetCurrentChain()>1 then
			g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,c,TYPE_PENDULUM)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		sg=g:SelectSubGroup(tp,cm.fselect,false,2,2,lv)
	elseif rpz==nil or lpz==nil then
		local seq=0
		if lpz then seq=4 end
		local z1=Duel.CheckLocation(tp,LOCATION_SZONE,seq)
		if not z1 then return false end
		local pz=lpz or rpz
		local scale=pz:GetLeftScale()
		local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,c,TYPE_PENDULUM)
		local fil=cm.dfilter
		if lv>scale then fil=cm.hfilter end
		if Duel.GetCurrentChain()>1 then
			g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,c,TYPE_PENDULUM)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		sg=g:FilterSelect(tp,fil,1,1,nil,lv)
	end
	for sc in aux.Next(sg) do
		if not sc:IsLocation(LOCATION_HAND) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			sc:RegisterEffect(e2)
		end
		Duel.MoveToField(sc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
	--cm.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if rpz==nil or lpz==nil then return false end
	local lscale=lpz:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local loc=0
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
	if ft1>0 then loc=loc|LOCATION_HAND end
	if ft2>0 then loc=loc|LOCATION_EXTRA end
	if loc==0 then return false end
	local _PendulumChecklist=aux.PendulumChecklist
	aux.PendulumChecklist=0
	local res=c:IsLocation(loc) and aux.PConditionFilter(c,e,tp,lscale,rscale,nil)
	aux.PendulumChecklist=_PendulumChecklist
	if not res then return false end
	Duel.HintSelection(Group.FromCards(lpz))
	Duel.HintSelection(Group.FromCards(rpz))
	local tc=c
	if not tc.pendulum_rule or not tc.pendulum_rule[tc] then
		local tcm=getmetatable(tc)
		tcm.pendulum_rule=tcm.pendulum_rule or {}
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
		tcm.pendulum_rule[tc]=e1
	else
		tc.pendulum_rule[tc]:SetLabel(1)
	end
	Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_PENDULUM)
end
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_PENDULUM) --re and re==c.pendulum_rule[c]
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local e1=Card.RegisterFlagEffect(c,m,RESET_EVENT+0x53e0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(m,0))
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetLabel(fid)
	e2:SetLabelObject(e1)
	e2:SetOperation(cm.tdop)
	Duel.RegisterEffect(e2,tp)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.tdfilter,1,nil,e:GetLabel()) then
		e:GetLabelObject():Reset()
		e:Reset()
	end
end
function cm.tdfilter(c,lab)
	local fid=c:GetFlagEffectLabel(m)
	return c:IsLocation(LOCATION_DECK) and fid and fid==lab
end
function cm.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9977)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.spfilter,1,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	if Duel.GetCurrentChain()>1 then
		e:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+0x200)
	else e:SetProperty(EFFECT_FLAG_DELAY) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,PLAYER_ALL,LOCATION_HAND+LOCATION_SZONE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	if #g==0 then return end
	local rg=g:RandomSelect(tp,1)
	rg:AddCard(c)
	if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)>0 then
		local og=Duel.GetOperatedGroup()
		og=og:Filter(cm.rffilter,nil)
		if og and #og>0 then
			for oc in aux.Next(og) do
				oc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11451911,4))
			end
			og:KeepAlive()
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(m,3))
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_ADJUST)
			e1:SetLabel(Duel.GetCurrentPhase())
			e1:SetLabelObject(og)
			e1:SetCondition(cm.retcon)
			e1:SetOperation(cm.retop)
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(cm.filter6,1,nil) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function cm.filter6(c)
	return c:GetFlagEffect(m)>0
end
function cm.rffilter(c)
	return c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT)
end
function cm.retfilter2(c,p,loc)
	if (c:IsPreviousLocation(LOCATION_SZONE) and c:GetPreviousTypeOnField()&TYPE_EQUIP>0) or c:IsPreviousLocation(LOCATION_FZONE) then return false end
	return c:IsPreviousControler(p) and c:IsPreviousLocation(loc)
end
function cm.fselect2(g,pft)
	return g:FilterCount(Card.IsPreviousLocation,nil,LOCATION_PZONE)<=pft
end
function cm.returntofield(tc)
	if tc:IsPreviousLocation(LOCATION_FZONE) then
		local p=tc:GetPreviousControler()
		local gc=Duel.GetFieldCard(p,LOCATION_FZONE,0)
		if gc then
			Duel.SendtoGrave(gc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		return
	end
	if tc:GetPreviousTypeOnField()&TYPE_EQUIP>0 then
		Duel.SendtoGrave(tc,REASON_RULE+REASON_RETURN)
	else
		Duel.ReturnToField(tc)
	end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	if pnfl_adjusting then return end
	local g=e:GetLabelObject()
	local sg=g:Filter(cm.filter6,nil,e)
	local ph,ph2=Duel.GetCurrentPhase(),e:GetLabel()
	if ph==ph2 or not (ph<=PHASE_MAIN1 or ph>=PHASE_MAIN2 or ph2<=PHASE_MAIN1 or ph2>=PHASE_MAIN2) then return end
	pnfl_adjusting=true
	g:DeleteGroup()
	e:Reset()
	local ft,mg,pft,pmg={},{},{},{}
	ft[1]=Duel.GetLocationCount(tp,LOCATION_MZONE)
	ft[2]=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	ft[3]=Duel.GetLocationCount(tp,LOCATION_SZONE)
	ft[4]=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	pft[3],pft[4]=0,0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then pft[3]=pft[3]+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then pft[3]=pft[3]+1 end
	if Duel.CheckLocation(1-tp,LOCATION_PZONE,0) then pft[4]=pft[4]+1 end
	if Duel.CheckLocation(1-tp,LOCATION_PZONE,1) then pft[4]=pft[4]+1 end
	mg[1]=sg:Filter(cm.retfilter2,nil,tp,LOCATION_MZONE)
	mg[2]=sg:Filter(cm.retfilter2,nil,1-tp,LOCATION_MZONE)
	mg[3]=sg:Filter(cm.retfilter2,nil,tp,LOCATION_SZONE)
	mg[4]=sg:Filter(cm.retfilter2,nil,1-tp,LOCATION_SZONE)
	pmg[3]=sg:Filter(cm.retfilter2,nil,tp,LOCATION_PZONE)
	pmg[4]=sg:Filter(cm.retfilter2,nil,1-tp,LOCATION_PZONE)
	for i=1,2 do
		if #mg[i]>ft[i] then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451461,7))
			local tg=mg[i]:Select(tp,ft[i],ft[i],nil)
			for tc in aux.Next(tg) do cm.returntofield(tc) end
			sg:Sub(tg)
		end
	end
	for i=3,4 do
		if #mg[i]>ft[i] then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451461,7))
			local ct=math.min(#(mg[i]-pmg[i])+pft[i],ft[i])
			local tg=mg[i]:SelectSubGroup(tp,cm.fselect2,false,ct,ct,pft[i])
			local ptg=tg:Filter(Card.IsPreviousLocation,nil,LOCATION_PZONE)
			for tc in aux.Next(ptg) do cm.returntofield(tc) end
			for tc in aux.Next(tg-ptg) do cm.returntofield(tc) end
			sg:Sub(tg)
		elseif #pmg[i]>pft[i] then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451461,7))
			local tg=pmg[i]:Select(tp,pft[i],pft[i],nil)
			for tc in aux.Next(tg) do cm.returntofield(tc) end
			sg:Sub(tg)
		end
	end
	local psg=sg:Filter(Card.IsPreviousLocation,nil,LOCATION_PZONE)
	for tc in aux.Next(psg) do cm.returntofield(tc) end
	for tc in aux.Next(sg-psg) do
		if tc:GetPreviousLocation()&LOCATION_ONFIELD>0 then
			cm.returntofield(tc)
		elseif tc:IsPreviousLocation(LOCATION_HAND) then
			Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
		end
	end
	pnfl_adjusting=false
end