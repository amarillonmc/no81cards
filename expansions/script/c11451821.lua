--龙宫城的微略 鼍丞
local cm,m=GetID()
function cm.initial_effect(c)
	--sp
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	--change effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.chcon)
	e4:SetOperation(cm.chop)
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD)
		ge0:SetCode(EFFECT_ACTIVATE_COST)
		ge0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge0:SetTargetRange(1,1)
		ge0:SetTarget(cm.chktg)
		ge0:SetOperation(cm.check0)
		Duel.RegisterEffect(ge0,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.check1)
		Duel.RegisterEffect(ge1,0)
		local ge5=Effect.CreateEffect(c)
		ge5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge5:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge5:SetOperation(cm.check)
		Duel.RegisterEffect(ge5,0)
		local ge6=Effect.CreateEffect(c)
		ge6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge6:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge6:SetOperation(cm.clear)
		Duel.RegisterEffect(ge6,0)
		cm[0]=Group.CreateGroup()
		cm[0]:KeepAlive()
		ge5:SetLabelObject(cm[0])
		ge6:SetLabelObject(cm[0])
	end
end
local _IsCanBeSpecialSummoned=Card.IsCanBeSpecialSummoned
function cm.chktg(e,te,tp)
	e:SetLabelObject(te)
	return true
end
function cm.check0(e,tp,eg,ep,ev,re,r,rp)
	local re=e:GetLabelObject()
	local tg=re:GetTarget()
	if tg then
		function Card.IsCanBeSpecialSummoned(c,e,st,...)
			if st&SUMMON_TYPE_RITUAL>0 then cm[1]=true end
			return _IsCanBeSpecialSummoned(c,e,st,...)
		end
		tg(e,tp,eg,ep,ev,re,r,rp,0)
		--Card.IsCanBeSpecialSummoned=_IsCanBeSpecialSummoned
		if cm[1] then cm[re]=true end
		cm[1]=nil
	end
end
function cm.check1(e,tp,eg,ep,ev,re,r,rp)
	local tg=re:GetTarget()
	if tg then
		Card.IsCanBeSpecialSummoned=_IsCanBeSpecialSummoned
		if cm[1] then cm[re]=true end
		cm[1]=nil
	end
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():Clear()
end
function cm.rlfilter(c)
	return c:IsSetCard(0x6978) and c:GetType()&0x81==0x81 and c.condition3 and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.check(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.rlfilter,nil)
	e:GetLabelObject():Merge(g)
	--[[for tc in aux.Next(g) do
		Duel.RegisterFlagEffect(0,m+tc:GetOriginalCode(),RESET_PHASE+PHASE_END,0,1)
		table.insert(cm[0],tc:GetOriginalCode())
	end--]]
end
function cm.lfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetReasonPlayer()==1-tp
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(cm.lfilter,1,nil,tp) and (not eg:IsContains(c) or c:IsLocation(LOCATION_HAND))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if #cm[0]==0 or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end
		for tc in aux.Next(cm[0]) do
			--local cn=_G["c"..code]
			local con=tc.condition3
			local op=tc.operation3
			local ft=0
			if tc:GetOriginalCode()==11451412 then ft=1 end
			if con and op and con(e,tp,eg,ep,ev,re,r,rp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>ft then return true end
		end
		return false
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local sg=Group.CreateGroup()
		for tc in aux.Next(cm[0]) do
			local con=tc.condition3
			local op=tc.operation3
			if con and op and con(e,tp,eg,ep,ev,re,r,rp) then sg:AddCard(tc) end
		end
		if #sg==0 then return end
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		tc.operation3(e,tp,eg,ep,ev,re,r,rp)
		Duel.SpecialSummonComplete()
	end
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetFlagEffect(tp,m)==0 and cm[re] and cm.spcon2(re,tp,eg,ep,ev,re,r,rp)
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(m,2)) then
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,cm.spop2)
	end
end
function cm.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
	if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1 --:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local lv=level_function(c)
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,lv*2,greater_or_equal)
	local res=mg:CheckSubGroup(aux.RitualCheck,1,lv*2,tp,c,lv*2,greater_or_equal)
	aux.GCheckAdditional=nil
	return res
end
function cm.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToRemove()
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return Duel.IsExistingMatchingCard(cm.RitualUltimateFilter,tp,LOCATION_DECK,0,1,nil,nil,e,tp,mg,nil,Card.GetLevel,"Greater")
end
function cm.rffilter(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	::cancel::
	local mg=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,cm.RitualUltimateFilter,tp,LOCATION_DECK,0,1,1,nil,nil,e,tp,mg,nil,Card.GetLevel,"Greater")
	if #tg>0 then
		local tc=tg:GetFirst()
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil,tp)
		end
		local lv=tc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,lv*2,"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,lv*2,tp,tc,lv*2,"Greater")
		aux.GCheckAdditional=nil
		if not mat then goto cancel end
		tc:SetMaterial(mat)
		local dg=mat:Filter(Card.IsFacedown,nil)
		if #dg>0 then Duel.ConfirmCards(1-tp,dg) end
		if Duel.Remove(mat,0,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL+REASON_TEMPORARY)~=0 then
			local fid=e:GetHandler():GetFieldID()
			local og1=Duel.GetOperatedGroup()
			local og=og1:Filter(cm.rffilter,nil)
			if og and #og>0 then
				for oc in aux.Next(og) do
					oc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
				end
				og:KeepAlive()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(11451461,0))
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetCountLimit(1)
				e1:SetLabel(fid)
				e1:SetLabelObject(og)
				e1:SetCondition(cm.retcon)
				e1:SetOperation(cm.retop)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function cm.filter6(c,e)
	return c:GetFlagEffectLabel(m)==e:GetLabel()
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
	end
	if tc:GetPreviousTypeOnField()&TYPE_EQUIP>0 then
		Duel.SendtoGrave(tc,REASON_RULE+REASON_RETURN)
	else
		Duel.ReturnToField(tc)
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(cm.filter6,1,nil,e) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(cm.filter6,nil,e)
	g:DeleteGroup()
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
	mg[5]=sg:Filter(cm.retfilter2,nil,tp,LOCATION_GRAVE)
	mg[6]=sg:Filter(cm.retfilter2,nil,1-tp,LOCATION_GRAVE)
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
		elseif tc:IsPreviousLocation(LOCATION_GRAVE) then
			Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
		end
	end
end