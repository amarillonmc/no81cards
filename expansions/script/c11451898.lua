--混沌之结界像
local cm,m=GetID()
function cm.initial_effect(c)
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(cm.sumlimit)
	c:RegisterEffect(e1)
	--remove
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,m)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_BOTH_SIDE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(cm.recon)
	e0:SetOperation(cm.reop)
	c:RegisterEffect(e0)
	local e2=e0:Clone()
	e2:SetCondition(cm.recon2)
	Duel.RegisterEffect(e2,0)
	local e4=e2:Clone()
	Duel.RegisterEffect(e4,1)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CUSTOM+m)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	--replace
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e5:SetCountLimit(1,11451896+EFFECT_COUNT_CODE_DUEL)
	e5:SetRange(LOCATION_HAND+LOCATION_DECK)
	e5:SetOperation(cm.rep)
	c:RegisterEffect(e5)
end
function cm.rep(e,tp,eg,ep,ev,re,r,rp)
	local table={19740112,10963799,47961808,73356503,46145256,84478195}
	for i,code in ipairs(table) do
		local cn=_G["c"..code]
		if type(cn)=="table" and type(cn.sumlimit)=="function" then
			cn.sumlimit=function(e,c,sump,sumtype,sumpos,targetp)
							return not c:IsAttribute(1<<(i-1))
						end
		end
		local g=Duel.GetMatchingGroup(aux.FilterEqualFunction(Card.GetOriginalCode,code),0,0xff,0xff,nil)
		for tc in aux.Next(g) do tc:ReplaceEffect(code,0) end
	end
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:GetAttribute()&(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)==0
end
function cm.recon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
end
function cm.recon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsControler(1-tp) and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	Duel.RaiseSingleEvent(c,EVENT_CUSTOM+m,e,0,0,0,sg:GetFirst():GetAttribute())
end
function cm.filter(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil):RandomSelect(tp,1)
	if not g or #g==0 then return end
	g:AddCard(c)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)>0 then
		local fid=c:GetFieldID()
		local og1=Duel.GetOperatedGroup()
		if og1:IsExists(cm.retfilter2,1,nil,tp,LOCATION_HAND) then Duel.ShuffleHand(tp) end
		if og1:IsExists(cm.retfilter2,1,nil,1-tp,LOCATION_HAND) then Duel.ShuffleHand(1-tp) end
		local og=og1:Filter(cm.rffilter,nil)
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
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,ev)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.spfilter(c,e,tp,attr)
	return c:IsAttribute(attr) and c:IsAttack(1000) and c:IsDefense(1000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.retfilter2(c,p,loc)
	if (c:IsPreviousLocation(LOCATION_SZONE) and c:GetPreviousTypeOnField()&TYPE_EQUIP>0) or c:IsPreviousLocation(LOCATION_FZONE) then return false end
	return c:IsPreviousControler(p) and c:IsPreviousLocation(loc)
end
function cm.rffilter(c)
	return c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT)
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
function cm.filter6(c,e)
	return c:GetFlagEffectLabel(m)==e:GetLabel()
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