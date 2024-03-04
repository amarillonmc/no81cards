--烈欲千变音「燎」
local cm,m=GetID()
function cm.initial_effect(c)
	--act in hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMING_ATTACK+TIMING_END_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.accost)
	e1:SetOperation(cm.acop)
	c:RegisterEffect(e1)
	--change effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(cm.ceop)
	--c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(TIMING_ATTACK,0x11e0)
	e3:SetCountLimit(1,m-40)
	e3:SetCost(cm.spcost)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetRange(LOCATION_HAND)
	e4:SetCost(cm.spcost2)
	c:RegisterEffect(e4)
end
function cm.lvplus(c)
	if c:GetLevel()>=1 and c:IsType(TYPE_MONSTER) then return c:GetLevel() else return 2 end
end
function cm.ceop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(cm.ceop2)
	Duel.RegisterEffect(e1,tp)
end
function cm.ceop2(e,tp,eg,ep,ev,re,r,rp)
	if rp==1-tp and re:GetHandler():IsCode(11451461) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.ChangeChainOperation(ev,cm.reop)
		e:Reset()
	end
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.Remove(c,POS_FACEUP,REASON_EFFECT) end
end
function cm.filter2(c,tp)
	return c:IsSetCard(0x97a) and ((c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD)) or (c:IsPublic() and c:IsLocation(LOCATION_HAND)) or c:IsLocation(LOCATION_GRAVE) or c:IsControler(tp)) and c:IsAbleToRemove()
end
function cm.filter22(c,e,tp)
	return c:IsSetCard(0x97a) and ((c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD)) or (c:IsPublic() and c:IsLocation(LOCATION_HAND)) or c:IsLocation(LOCATION_GRAVE) or c:IsControler(tp)) and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function cm.filter3(c,e,tp)
	return c:IsSetCard(0x97a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.filter4(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_TUNER)
end
function cm.filter5(c)
	return Duel.IsPlayerAffectedByEffect(c:GetControler(),11451461) and ((c:IsOnField() and c:IsStatus(STATUS_EFFECT_ENABLED)) or c:IsLocation(LOCATION_HAND))
end
function cm.filter6(c,e)
	return c:GetFlagEffectLabel(m)==e:GetLabel()
end
function cm.fselect(g,ng,goal,tp)
	if not (g:IsExists(cm.filter4,1,nil) and g:GetSum(cm.lvplus)>=goal) then
		return false
	elseif g:GetSum(cm.lvplus)==goal and Duel.GetMZoneCount(tp,g)>0 then
		return true
	end
	aux.GCheckAdditional=cm.hspgcheck2
	local tc=ng:CheckSubGroup(cm.fselect3,1,#ng,g,g:GetSum(cm.lvplus)-goal,tp)
	aux.GCheckAdditional=nil
	return tc
end
function cm.fselect3(g,g1,lv,tp)
	return g:GetSum(cm.lvplus)==lv and Duel.GetMZoneCount(tp,g+g1)>0
end
function cm.hspgcheck(g,c,mg,f,min,max,ext_params)
	local ng,goal,tp=table.unpack(ext_params)
	if g:GetSum(cm.lvplus)<=goal then return true end
	return cm.fselect(g,ng,goal,tp)
end
function cm.hspgcheck2(g,c,mg,f,min,max,ext_params)
	local g1,lv,tp=table.unpack(ext_params)
	if g:GetSum(cm.lvplus)<=lv then return true end
	return cm.fselect3(g,g1,lv,tp)
end
function cm.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11451461,6))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1600) end
	Duel.PayLPCost(tp,1600)
end
function cm.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsPublic() and Duel.GetFlagEffect(tp,11451466)>0 and Duel.CheckLPCost(tp,1600) end
	Duel.ResetFlagEffect(tp,11451466)
	Duel.PayLPCost(tp,1600)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,nil,tp)
		local sg=Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_DECK,0,nil,e,tp)
		local trg=mg:Filter(Card.IsType,nil,TYPE_TUNER)
		local ng=mg-trg
		local tg=Group.CreateGroup()
		for sc in aux.Next(sg) do
			--aux.GCheckAdditional=cm.hspgcheck
			local tc=trg:CheckSubGroup(cm.fselect,1,#trg,ng,cm.lvplus(sc),tp)
			--aux.GCheckAdditional=nil
			if tc then return true end
		end
		return false
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,PLAYER_ALL,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cm.filter22,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,nil,e,tp)
	local sg=Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_DECK,0,nil,e,tp)
	local trg=mg:Filter(Card.IsType,nil,TYPE_TUNER)
	local ng=mg-trg
	local tg=Group.CreateGroup()
	for sc in aux.Next(sg) do
		--aux.GCheckAdditional=cm.hspgcheck
		local tc=trg:CheckSubGroup(cm.fselect,1,#trg,ng,cm.lvplus(sc),tp)
		--aux.GCheckAdditional=nil
		if tc then tg:AddCard(sc) end
	end
	if not tg or #tg==0 then return end
	local rg,rg2=Group.CreateGroup(),Group.CreateGroup()
	local tc=tg:GetFirst()
	local res=false
	while not res do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		tc=tg:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,6))
		--aux.GCheckAdditional=cm.hspgcheck
		rg=trg:SelectSubGroup(tp,cm.fselect,true,1,#trg,ng,cm.lvplus(tc),tp)
		if rg and #rg>0 and rg:GetSum(cm.lvplus)>cm.lvplus(tc) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,7))
			aux.GCheckAdditional=cm.hspgcheck2
			rg2=ng:SelectSubGroup(tp,cm.fselect3,true,1,#ng,rg,rg:GetSum(cm.lvplus)-cm.lvplus(tc),tp)
			aux.GCheckAdditional=nil
			if rg2 and #rg2>0 then
				res=true
				rg:Merge(rg2)
			end
		elseif rg and #rg>0 and rg:GetSum(cm.lvplus)==cm.lvplus(tc) then
			res=true
		end
	end
	Duel.ConfirmCards(1-tp,rg:Filter(Card.IsFacedown,nil))
	local tg=rg:Filter(cm.filter5,nil)
	if not tg or #tg==0 then
		if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)>0 then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
	else
		Duel.Hint(HINT_CARD,0,11451461)
		if tg:IsExists(Card.IsControler,1,nil,tp) then Duel.IsPlayerAffectedByEffect(tp,11451461):GetHandler():RegisterFlagEffect(11451468,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11451461,1)) end
		if tg:IsExists(Card.IsControler,1,nil,1-tp) then Duel.IsPlayerAffectedByEffect(1-tp,11451461):GetHandler():RegisterFlagEffect(11451468,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11451461,1)) end
		if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)>0 then
			local fid=c:GetFieldID()
			local og1=Duel.GetOperatedGroup()
			if og1:IsExists(cm.retfilter2,1,nil,tp,LOCATION_HAND) then Duel.ShuffleHand(tp) end
			if og1:IsExists(cm.retfilter2,1,nil,1-tp,LOCATION_HAND) then Duel.ShuffleHand(1-tp) end
			local og=Group.__band(og1,tg):Filter(cm.rffilter,nil)
			if og and #og>0 then
				for oc in aux.Next(og) do
					oc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
				end
				og:KeepAlive()
				local e1=Effect.CreateEffect(c)
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
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
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
end