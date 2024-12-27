--塞西莉
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60000163)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,4)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(cm.xyztg)
	e1:SetOperation(cm.xyzop)
	c:RegisterEffect(e1)

	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e11:SetProperty(EFFECT_FLAG_DELAY)
	e11:SetCode(EVENT_CHAINING)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCondition(cm.cpcon)
	e11:SetTarget(cm.cptg)
	e11:SetOperation(cm.cpop)
	c:RegisterEffect(e11)


	--special summon
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_LEAVE_FIELD_P)
	e7:SetCondition(cm.acon)
	e7:SetOperation(cm.aop)
	c:RegisterEffect(e7)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetLabelObject(e7)
	e2:SetCondition(cm.bcon)
	e2:SetTarget(cm.btg)
	e2:SetOperation(cm.bop)
	c:RegisterEffect(e2)
end
function cm.xyzfil(c,code)
	return c:IsCode(code)
end
function cm.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tf=true
	for i=1,3 do
		if not Duel.IsExistingMatchingCard(cm.xyzfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil,m+i) then
			tf=false
		end
	end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and tf end
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tf=true
	for i=1,3 do
		if not Duel.IsExistingMatchingCard(cm.xyzfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil,m+i) then
			tf=false
		end
	end
	if not tf or not c:IsRelateToEffect(e) then return end
	local xyzg=Group.CreateGroup()
	for i=1,3 do
		local gg=Duel.GetMatchingGroup(cm.xyzfil,tp,LOCATION_GRAVE,0,nil,m+i)
		local dg=Duel.GetMatchingGroup(cm.xyzfil,tp,LOCATION_DECK,0,nil,m+i)
		if #gg>=2 then xyzg:Merge(gg:RandomSelect(tp,2))
		else 
			if #gg~=0 then xyzg:Merge(gg) end
			xyzg:Merge(dg:RandomSelect(tp,2-#gg))
		end
	end
	if #xyzg~=6 then return end
	Duel.Overlay(c,xyzg)
	local i=math.random(4,5)
	Duel.Hint(24,0,aux.Stringid(60000169,i))
end
function cm.tttcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),60000163) and e:GetHandler():GetOverlayCount()==0
end
function cm.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():GetType()~=TYPE_SPELL and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) --and re:GetHandler()==e:GetHandler()
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	if #og==0 then return end
	Duel.SendtoGrave(og:RandomSelect(tp,1),REASON_RULE+REASON_EFFECT)
	local ag=Duel.GetOperatedGroup()
	if ag and #ag:Filter(cm.cpfil,nil)~=0 then
		local tc=ag:GetFirst()
		local te=tc:CheckActivateEffect(true,true,false)
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
	local i=math.random(6,8)
	Duel.Hint(24,0,aux.Stringid(60000169,i))
	local tf=true
	for i=1,3 do
		if not Duel.IsExistingMatchingCard(cm.xyzfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil,m+i) then
			tf=false
		end
	end
	if c:GetOverlayCount()==0 and Duel.GetFlagEffect(tp,m)<6 and tf then
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		local xyzg=Group.CreateGroup()
		for i=1,3 do
			local gg=Duel.GetMatchingGroup(cm.xyzfil,tp,LOCATION_GRAVE,0,nil,m+i)
			local dg=Duel.GetMatchingGroup(cm.xyzfil,tp,LOCATION_DECK,0,nil,m+i)
			if #gg>=2 then xyzg:Merge(gg:RandomSelect(tp,2))
			else 
				if #gg~=0 then xyzg:Merge(gg) end
				xyzg:Merge(dg:RandomSelect(tp,2-#gg))
			end
		end
		if #xyzg~=6 then return end
		Duel.Hint(HINT_CARD,0,60000178)
		Duel.Overlay(c,xyzg)
	end
end
function cm.cpfil(c)
	return aux.IsCodeListed(c,60000163) and c:GetType()==TYPE_SPELL and c:CheckActivateEffect(true,true,false)~=nil
end
--random
function getrand()
	local result=0
	local g=Duel.GetDecktopGroup(0,5)
	local tc=g:GetFirst()
	while tc do
		result=result+tc:GetCode()
		tc=g:GetNext()
	end
	math.randomseed(result)
end



function cm.acon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),60000163) and e:GetHandler():GetOverlayCount()~=0
end
function cm.aop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,60000178)
	local g=e:GetHandler():GetOverlayGroup()
	e:SetLabelObject(g)
end

function cm.bcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),60000163)
end
function cm.btg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=e:GetLabelObject():GetLabelObject()
	if chk==0 then return tg and aux.GetValueType(tg)=="Group"and #tg>0 end
end
function cm.bop(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetLabelObject():GetLabelObject()
	if not tg then return end
	for tc in aux.Next(tg) do
		if tc:GetType()==TYPE_SPELL and aux.IsCodeListed(tc,60000163) then
			Duel.Hint(HINT_CARD,0,tc:GetCode())
			local te=tc:CheckActivateEffect(true,true,false)
			if te then
				e:SetLabelObject(te:GetLabelObject())
				local op=te:GetOperation()
				if op then op(e,tp,eg,ep,ev,re,r,rp) end
			end
		end
	end
end












