--朱之汐雏 逆卷之炎
local cm,m=GetID()
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--trigger
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(cm.pspcon)
	e1:SetTarget(cm.psptg)
	e1:SetOperation(cm.pspop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(m,4))
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(aux.TRUE)
	c:RegisterEffect(e3)
	local e5=e1:Clone()
	e5:SetDescription(aux.Stringid(m,5))
	e5:SetCode(EVENT_MOVE)
	e5:SetCondition(cm.pspcon2)
	c:RegisterEffect(e5)
	local e4=e1:Clone()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetTarget(cm.psptg2(11451911))
	c:RegisterEffect(e4)
	local e6=e3:Clone()
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetTarget(cm.psptg2(11451913))
	c:RegisterEffect(e6)
	local e8=e5:Clone()
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetTarget(cm.psptg2(11451915))
	c:RegisterEffect(e8)
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
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(11451912)
	e0:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	c:RegisterEffect(e0)
	if not STRIDGON_REPSPSUMMON_CHECK then
		STRIDGON_REPSPSUMMON_CHECK=true
		local _PConditionFilter=aux.PConditionFilter
		function aux.PConditionFilter(c,e,...)
			cm[0]=e
			return _PConditionFilter(c,e,...)
		end
		local _PendOperationCheck=aux.PendOperationCheck
		function aux.PendOperationCheck(ft1,ft2,ft)
			cm[2]=true
			return _PendOperationCheck(ft1,ft2,ft)
		end
		local _SelectSubGroup=Group.SelectSubGroup
		function Group.SelectSubGroup(...)
			local res=_SelectSubGroup(...)
			if res and cm[0] and cm[2] then cm[1]=cm[0] end
			cm[0]=nil
			cm[2]=nil
			return res
		end
		local _Merge=Group.Merge
		function Group.Merge(sg,obj)
			if cm[1]==nil or (aux.GetValueType(obj)=="Group" and #obj~=1) then cm[1]=nil return _Merge(sg,obj) end
			local tc=obj
			if aux.GetValueType(obj)=="Group" then tc=obj:GetFirst() end
			local tp=tc:GetControler()
			if 1==1 then --and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451912,0))
				local tg=Duel.GetMatchingGroup(cm.tspfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,nil,tp,tc):CancelableSelect(tp,0,1,nil)
				if tg and #tg>0 then Duel.RegisterFlagEffect(tp,tg:GetFirst():GetOriginalCode(),RESET_PHASE+PHASE_END,0,1) cm[1]=nil Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(11451912,6)) return _Merge(sg,tg) end
			end
			cm[1]=nil
			return _Merge(sg,obj)
		end
		local _SpecialSummonRule=Duel.SpecialSummonRule
		function Duel.SpecialSummonRule(tp,tc,sumtype)
			if sumtype~=SUMMON_TYPE_PENDULUM then _SpecialSummonRule(tp,tc,sumtype) end
			local tp=tc:GetControler()
			if 1==1 then --and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451912,0))
				local tg=Duel.GetMatchingGroup(cm.tspfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,nil,tp,tc):CancelableSelect(tp,0,1,nil)
				if tg and #tg>0 then Duel.RegisterFlagEffect(tp,tg:GetFirst():GetOriginalCode(),RESET_PHASE+PHASE_END,0,1) local tc2=tg:GetFirst() tc2.pendulum_rule[tc2]:SetLabel(1) if tc.pendulum_rule and tc.pendulum_rule[tc] then tc.pendulum_rule[tc]:SetLabel(0) end Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(11451912,6)) return _SpecialSummonRule(tp,tc2,SUMMON_TYPE_PENDULUM) end
			end
			_SpecialSummonRule(tp,tc,sumtype)
		end
	end
end
function cm.tspfilter(c,e,tp)
	if not c:IsHasEffect(11451912) or Duel.GetFlagEffect(tp,c:GetOriginalCode())>0 or (e and not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)) then return false end
	if not e then
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
		if not tc:IsCanBeSpecialSummoned(tc.pendulum_rule[tc],SUMMON_TYPE_PENDULUM,tp,false,false) then tc.pendulum_rule[tc]:SetLabel(0) return false end
		tc.pendulum_rule[tc]:SetLabel(0)
	end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
	local ft=Duel.GetUsableMZoneCount(tp)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect and ect<ft2 then ft2=ect end
	local g=Group.FromCards(c)
	local ext=g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
	return ext<=ft2 and #g-ext<=ft1 and #g<=ft
end
function cm.pspcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetActivateLocation()==LOCATION_HAND
end
function cm.spfilter0(c,loc)
	return c:IsPreviousLocation(loc) and not (c:IsLocation(loc) and c:IsControler(c:GetPreviousControler()))
end
function cm.pspcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.spfilter0,1,nil,LOCATION_DECK) and (not eg:IsContains(e:GetHandler()) or e:GetHandler():IsLocation(LOCATION_HAND))
end
function cm.thfilter(c,...)
	local tab={...}
	for _,code in ipairs(tab) do
		if c:GetOriginalCode()==code and c:IsAbleToHand() then return true end
	end
	return false
end
function cm.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tab0={11451911,11451913,11451915}
	local tab={}
	for _,code in ipairs(tab0) do
		if c:GetFlagEffect(code)>0 then tab[#tab+1]=code end
	end
	if chk==0 then
		return #tab>0 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,table.unpack(tab))
	end
	e:SetLabel(table.unpack(tab))
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function cm.psptg2(code)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
				local c=e:GetHandler()
				if chk==0 then
					c:RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
					return false
				end
			end
end
function cm.pspop(e,tp,eg,ep,ev,re,r,rp)
	local tab={e:GetLabel()}
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,table.unpack(tab))
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,1,nil) --SelectSubGroup(tp,aux.dncheck,false,1,g:GetClassCount(Card.GetOriginalCode))
	if #sg>0 and Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,sg)
	end
end
function cm.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9977)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.spfilter,1,nil)
end
function cm.rmfilter(c)
	return c:IsStatus(STATUS_EFFECT_ENABLED) and c:IsAbleToRemove()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	if Duel.GetCurrentChain()>1 then
		e:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+0x200)
	else e:SetProperty(EFFECT_FLAG_DELAY) end
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
	if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)>0 then
		local og=Duel.GetOperatedGroup()
		og=og:Filter(cm.rffilter,nil)
		if og and #og>0 then
			for oc in aux.Next(og) do
				oc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11451911,4))
			end
			og:KeepAlive()
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(m,1))
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
	if not g or not g:IsExists(cm.filter6,1,nil) then
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
	tc:ResetFlagEffect(m)
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