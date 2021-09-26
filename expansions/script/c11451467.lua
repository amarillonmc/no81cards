--碎灭万华音「萤」
local m=11451467
local cm=_G["c"..m]
function cm.initial_effect(c)
	--change code
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.chcost)
	e1:SetOperation(cm.chop)
	c:RegisterEffect(e1)
	--change attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(cm.caop)
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
function cm.caop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetTargetRange(0x7f,0x7f)
	e1:SetTarget(cm.catg)
	e1:SetLabelObject(tc)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(TYPE_TUNER)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetValue(cm.caval)
	Duel.RegisterEffect(e2,tp)
end
function cm.catg(e,c)
	return c:IsCode(11451461) and c:IsType(TYPE_MONSTER)
end
function cm.caval(e,c)
	if c:IsAttribute(ATTRIBUTE_DEVINE) then return 0x7f end
	return 0x3f
end
function cm.filter2(c)
	return c:IsSetCard(0x97a) and ((c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD)) or (c:IsPublic() and c:IsLocation(LOCATION_HAND)) or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToRemove()
end
function cm.filter3(c,e,tp)
	return c:IsSetCard(0x97a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.filter4(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_TUNER)
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
	elseif g:GetSum(cm.lvplus)==goal then
		return true
	end
	aux.GCheckAdditional=cm.hspgcheck2
	local tc=ng:CheckSubGroup(cm.hspcheck2,1,#ng,g,g:GetSum(cm.lvplus)-goal,tp)
	aux.GCheckAdditional=nil
	return tc
end
function cm.fselect2(g,g1,lv,tp)
	return g:GetSum(cm.lvplus)==lv and Duel.GetMZoneCount(tp,g+g1)>0
end
function cm.hspcheck(g,ng,goal,tp)
	Duel.SetSelectedCard(g)
	return g:CheckSubGroup(cm.fselect,1,#g,ng,goal,tp)
end
function cm.hspgcheck(g,c,mg,f,min,max,ext_params)
	local ng,goal,tp=table.unpack(ext_params)
	if g:GetSum(cm.lvplus)<=goal then return true end
	Duel.SetSelectedCard(g)
	return g:CheckSubGroup(cm.fselect,1,#g,ng,goal,tp)
end
function cm.hspcheck2(g,g1,lv,tp)
	Duel.SetSelectedCard(g)
	return g:CheckSubGroup(cm.fselect2,1,#g,g1,lv,tp)
end
function cm.hspgcheck2(g,c,mg,f,min,max,ext_params)
	local g1,lv,tp=table.unpack(ext_params)
	if g:GetSum(cm.lvplus)<=lv then return true end
	Duel.SetSelectedCard(g)
	return g:CheckSubGroup(cm.fselect2,1,#g,g1,lv,tp)
end
function cm.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
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
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(cm.chop2)
	Duel.RegisterEffect(e1,tp)
end
function cm.chop2(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) then
		local tc=re:GetHandler()
		local g=Duel.GetMatchingGroup(cm.chfilter,0,0xff,0xff,nil,tc)
		for sc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(11451461,5))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EFFECT_ADD_CODE)
			e1:SetRange(0xff)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetValue(11451461)
			sc:RegisterEffect(e1)
		end
	end
end
function cm.chfilter(c,tc)
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
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
		local mg=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
		local sg=Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_DECK,0,nil,e,tp)
		local trg=mg:Filter(Card.IsType,nil,TYPE_TUNER)
		local ng=mg-trg
		local tg=Group.CreateGroup()
		for sc in aux.Next(sg) do
			aux.GCheckAdditional=cm.hspgcheck
			local tc=trg:CheckSubGroup(cm.fselect,1,#trg,ng,cm.lvplus(sc),tp)
			aux.GCheckAdditional=nil
			if tc then return true end
		end
		return false
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,nil)
	local sg=Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_DECK,0,nil,e,tp)
	local trg=mg:Filter(Card.IsType,nil,TYPE_TUNER)
	local ng=mg-trg
	local tg=Group.CreateGroup()
	for sc in aux.Next(sg) do
		aux.GCheckAdditional=cm.hspgcheck
		local tc=trg:CheckSubGroup(cm.hspcheck,1,#trg,ng,cm.lvplus(sc),tp)
		aux.GCheckAdditional=nil
		if tc then tg:AddCard(sc) end
	end
	if not tg or #tg==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=tg:Select(tp,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,6))
	aux.GCheckAdditional=cm.hspgcheck
	local rg=trg:SelectSubGroup(tp,cm.hspcheck,false,1,#trg,ng,cm.lvplus(tc),tp)
	if rg:GetSum(cm.lvplus)>cm.lvplus(tc) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,7))
		aux.GCheckAdditional=cm.hspgcheck2
		local rg2=ng:SelectSubGroup(tp,cm.hspcheck2,false,1,#ng,rg,rg:GetSum(cm.lvplus)-cm.lvplus(tc),tp)
		rg:Merge(rg2)
	end
	aux.GCheckAdditional=nil
	local tg=rg:Filter(cm.filter5,nil)
	if not tg or #tg==0 then
		if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)>0 then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
	else
		Duel.Hint(HINT_CARD,0,11451461)
		if tg:IsExists(Card.IsControler,1,nil,tp) then Duel.IsPlayerAffectedByEffect(tp,11451461):GetHandler():RegisterFlagEffect(11451468,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11451461,1)) end
		if tg:IsExists(Card.IsControler,1,nil,1-tp) then Duel.IsPlayerAffectedByEffect(1-tp,11451461):GetHandler():RegisterFlagEffect(11451468,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11451461,1)) end
		if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)>0 then
			sp=1
			local fid=c:GetFieldID()
			local og1=Duel.GetOperatedGroup()
			if og1:IsExists(cm.retfilter2,1,nil,tp,LOCATION_HAND) then Duel.ShuffleHand(tp) end
			if og1:IsExists(cm.retfilter2,1,nil,1-tp,LOCATION_HAND) then Duel.ShuffleHand(1-tp) end
			local og=Group.__band(og1,tg):Filter(Card.IsLocation,nil,LOCATION_REMOVED)
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
function cm.retfilter2(c,p,loc)
	return c:IsPreviousControler(p) and c:IsPreviousLocation(loc)
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
	local ft,mg={},{}
	ft[1]=Duel.GetLocationCount(tp,LOCATION_MZONE)
	ft[2]=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	ft[3]=Duel.GetLocationCount(tp,LOCATION_SZONE)
	ft[4]=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	mg[1]=sg:Filter(cm.retfilter2,nil,tp,LOCATION_MZONE)
	mg[2]=sg:Filter(cm.retfilter2,nil,1-tp,LOCATION_MZONE)
	mg[3]=sg:Filter(cm.retfilter2,nil,tp,LOCATION_SZONE)
	mg[4]=sg:Filter(cm.retfilter2,nil,1-tp,LOCATION_SZONE)
	for i=1,4 do
		if #mg[i]>ft[i] then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
			local tg=mg[i]:Select(tp,ft[i],ft[i],nil)
			for tc in aux.Next(tg) do Duel.ReturnToField(tc) end
			sg:Sub(tg)
		end
	end
	for tc in aux.Next(sg) do
		if tc:GetPreviousLocation()&LOCATION_ONFIELD>0 then
			Duel.ReturnToField(tc)
		elseif tc:IsPreviousLocation(LOCATION_HAND) then
			Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
		end
	end
end