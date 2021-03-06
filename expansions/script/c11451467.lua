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
	c:RegisterEffect(e2)
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
	if c:GetLevel()>=1 and c:IsType(TYPE_TUNER) and c:IsType(TYPE_MONSTER) then return c:GetLevel() elseif c:GetLevel()>=1 and c:IsType(TYPE_MONSTER) then return -c:GetLevel() else return -2 end
end
function cm.chtg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
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
	return c:IsCode(11451460) and c:IsType(TYPE_MONSTER)
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
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),11451461) and ((c:IsOnField() and c:IsStatus(STATUS_EFFECT_ENABLED)) or c:IsLocation(LOCATION_HAND)) then return true end
	return false
end
function cm.filter6(c,e)
	return c:GetFlagEffectLabel(m)==e:GetLabel()
end
function cm.filter7(c)
	return not c:IsPublic()
end
function cm.fselect(g,lv,tp)
	return g:GetSum(cm.lvplus)==lv and g:IsExists(cm.filter4,1,nil) and Duel.GetMZoneCount(tp,g,tp,0,0x1f)>0
end
function cm.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
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
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetRange(0xff)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetValue(11451460)
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
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,nil)
	local sg=Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_DECK,0,nil,e,tp)
	local tg=Group.CreateGroup()
	for sc in aux.Next(sg) do
		aux.GCheckAdditional=aux.TRUE
		local tc=mg:CheckSubGroup(cm.fselect,1,3,cm.lvplus(sc),tp)
		aux.GCheckAdditional=nil
		if tc then tg:AddCard(sc) end
	end
	if not tg or #tg==0 or not Duel.SelectYesNo(tp,aux.Stringid(11451461,2)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=tg:Select(tp,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	aux.GCheckAdditional=aux.TRUE
	local rg=mg:SelectSubGroup(tp,cm.fselect,false,1,3,cm.lvplus(tc),tp)
	aux.GCheckAdditional=nil
	Card.SetMaterial(tc,rg)
	local tg=rg:Filter(cm.filter5,nil)
	if not tg or #tg==0 then
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL)
	else
		Duel.Hint(HINT_CARD,0,11451461)
		local te0=Duel.IsPlayerAffectedByEffect(0,11451461)
		local te1=Duel.IsPlayerAffectedByEffect(1,11451461)
		local tg0=tg:Filter(Card.IsControler,nil,0)
		local tg1=tg:Filter(Card.IsControler,nil,1)
		rg:Sub(tg)
		if te0 and tg0 then
			te0:GetHandler():RegisterFlagEffect(11451468,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			local tg0f=tg0:Filter(Card.IsOnField,nil)
			local tg0h=tg0:Filter(Card.IsLocation,nil,LOCATION_HAND)
			if tg0f and Duel.Remove(tg0f,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_TEMPORARY)>0 then
				tg0f:KeepAlive()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(11451461,0))
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetReset(RESET_PHASE+PHASE_END)
				e1:SetLabelObject(tg0f)
				e1:SetCountLimit(1)
				e1:SetOperation(cm.retop1)
				Duel.RegisterEffect(e1,tp)
			end
			if tg0h and Duel.Remove(tg0h,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL)>0 then
				Duel.ShuffleHand(tp)
				local fid=c:GetFieldID()
				tg0h:ForEach(Card.RegisterFlagEffect,m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
				tg0h:KeepAlive()
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetDescription(aux.Stringid(11451461,1))
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_PHASE+PHASE_END)
				e2:SetCountLimit(1)
				e2:SetLabel(fid)
				e2:SetLabelObject(tg0h)
				e2:SetReset(RESET_PHASE+PHASE_END)
				e2:SetOperation(cm.retop2)
				Duel.RegisterEffect(e2,tp)
			end
		end
		if te1 and tg1 then
			te1:GetHandler():RegisterFlagEffect(11451468,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			local tg1f=tg1:Filter(Card.IsOnField,nil)
			local tg1h=tg1:Filter(Card.IsLocation,nil,LOCATION_HAND)
			if tg1f and Duel.Remove(tg1f,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_TEMPORARY)>0 then
				tg1f:KeepAlive()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(11451461,0))
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetReset(RESET_PHASE+PHASE_END)
				e1:SetLabelObject(tg1f)
				e1:SetCountLimit(1)
				e1:SetOperation(cm.retop1)
				Duel.RegisterEffect(e1,tp)
			end
			if tg1h and Duel.Remove(tg1h,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL)>0 then
				Duel.ShuffleHand(tp)
				local fid=c:GetFieldID()
				tg1h:ForEach(Card.RegisterFlagEffect,m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
				tg1h:KeepAlive()
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetDescription(aux.Stringid(11451461,1))
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_PHASE+PHASE_END)
				e2:SetCountLimit(1)
				e2:SetLabel(fid)
				e2:SetLabelObject(tg1h)
				e2:SetReset(RESET_PHASE+PHASE_END)
				e2:SetOperation(cm.retop2)
				Duel.RegisterEffect(e2,tp)
			end
		end
		if rg then Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL) end
	end
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
function cm.retop1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	for tc in aux.Next(g) do
		Duel.ReturnToField(tc)
	end
	g:DeleteGroup()
end
function cm.retop2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(cm.filter6,nil,e)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	e:GetLabelObject():DeleteGroup()
end