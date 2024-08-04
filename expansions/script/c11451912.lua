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
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
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
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,g:GetClassCount(Card.GetOriginalCode))
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
				oc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
			end
			og:KeepAlive()
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(m,1))
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_ADJUST)
			e1:SetCountLimit(1)
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
	end
	if tc:GetPreviousTypeOnField()&TYPE_EQUIP>0 then
		Duel.SendtoGrave(tc,REASON_RULE+REASON_RETURN)
	else
		Duel.ReturnToField(tc)
	end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(cm.filter6,nil,e)
	local ph,ph2=Duel.GetCurrentPhase(),e:GetLabel()
	if ph==ph2 or not (ph<=PHASE_MAIN1 or ph>=PHASE_MAIN2 or ph2<=PHASE_MAIN1 or ph2>=PHASE_MAIN2) then return end
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