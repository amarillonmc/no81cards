local m=15000392
local cm=_G["c"..m]
cm.name="替身名-『南北战争』"
function cm.initial_effect(c)
	--public
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,15000392)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--CivilWar
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e4:SetCode(EFFECT_SEND_REPLACE)
	e4:SetTarget(cm.reptg)
	e4:SetValue(cm.repval)
	c:RegisterEffect(e4)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e4:SetLabelObject(g)
	--CivilWar
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetTarget(cm.rep2tg)
	e3:SetValue(cm.repval)
	c:RegisterEffect(e3)
	local ag=Group.CreateGroup()
	ag:KeepAlive()
	e3:SetLabelObject(ag)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local fid=c:GetFieldID()
	c:RegisterFlagEffect(15000391,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,66)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function cm.repfilter(c,e)
	local p=c:GetControler()
	if c:IsLocation(LOCATION_OVERLAY) then p=c:GetOverlayTarget():GetControler() end
	return c:GetDestination()==LOCATION_GRAVE and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,p,false,false)
		and Duel.GetMZoneCount(1-p,c,p)>0
		and not c:IsLocation(LOCATION_MZONE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ((e:GetHandler():IsPublic() and e:GetHandler():IsLocation(LOCATION_HAND)) or e:GetHandler():IsLocation(LOCATION_MZONE))
		and eg:IsExists(cm.repfilter,1,nil,e) and ((not re) or re~=e) end
	if eg:IsExists(cm.repfilter,1,nil,e) and ((not re) or re~=e) then
		local container=e:GetLabelObject()
		container:Clear()
		local g=eg:Filter(cm.repfilter,nil,e)
		local g1=g:Filter(Card.IsControler,nil,0)
		local g2=g:Filter(Card.IsControler,nil,1)
		local ct1=g1:GetCount()
		local ct2=g2:GetCount()
		local ct=ct1+ct2
		local tc=g:GetFirst()
		while tc do
			local p=tc:GetControler()
			if tc:IsLocation(LOCATION_OVERLAY) then p=tc:GetOverlayTarget():GetControler() end
			local ft=Duel.GetMZoneCount(1-p,tc,p)
			if not ((p==0 and ft>=ct1) or (p==1 and ft>=ct2)) then return false end
			tc=g:GetNext()
		end
		local ag=Group.CreateGroup()
		local tc=g:GetFirst()
		while tc do
			local p=tc:GetControler()
			if tc:IsLocation(LOCATION_OVERLAY) then p=tc:GetOverlayTarget():GetControler() end
			if Duel.SpecialSummonStep(tc,0,p,1-p,false,false,POS_FACEUP) then ag:AddCard(tc) end
			tc:RegisterFlagEffect(15000392,RESET_EVENT+0x1de0000+RESET_PHASE+PHASE_END,0,1)
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
		container:Merge(g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,1))
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.tdcon)
		e1:SetOperation(cm.tdop)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		Duel.RegisterEffect(e1,tp)
		return true
	else return false end
end
function cm.rep2filter(c,e)
	return c:GetDestination()==LOCATION_GRAVE and c:IsType(TYPE_MONSTER)
		and c:IsControlerCanBeChanged()
		and Duel.GetMZoneCount(1-c:GetControler(),c,c:GetControler())>0
		and c:IsLocation(LOCATION_MZONE) and not c:IsLocation(LOCATION_OVERLAY)
end
function cm.rep2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ((e:GetHandler():IsPublic() and e:GetHandler():IsLocation(LOCATION_HAND)) or e:GetHandler():IsLocation(LOCATION_MZONE))
		and eg:IsExists(cm.rep2filter,1,nil,e) and ((not re) or re~=e) end
	if eg:IsExists(cm.rep2filter,1,nil,e) and ((not re) or re~=e) then
		local container=e:GetLabelObject()
		container:Clear()
		local g=eg:Filter(cm.rep2filter,nil,e)
		local g1=g:Filter(Card.IsControler,nil,0)
		local g2=g:Filter(Card.IsControler,nil,1)
		local ct1=g1:GetCount()
		local ct2=g2:GetCount()
		local ct=ct1+ct2
		local tc=g:GetFirst()
		while tc do
			local ft=Duel.GetMZoneCount(1-tc:GetControler(),tc,tc:GetControler())
			if not ((tc:GetControler()==0 and ft>=ct1) or (tc:GetControler()==1 and ft>=ct2)) then return false end
			tc=g:GetNext()
		end
		local ag=Group.CreateGroup()
		local tc=g:GetFirst()
		while tc do
			local p=tc:GetControler()
			if Duel.GetControl(tc,1-p)~=0 then ag:AddCard(tc) end
			tc:RegisterFlagEffect(15000392,RESET_EVENT+0x1de0000+RESET_PHASE+PHASE_END,0,1)
			tc=g:GetNext()
		end
		container:Merge(g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,1))
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.tdcon)
		e1:SetOperation(cm.tdop)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		Duel.RegisterEffect(e1,tp)
		return true
	else return false end
end
function cm.repval(e,c)
	return e:GetLabelObject():IsContains(c)
end
function cm.tdfilter(c)
	return c:GetFlagEffect(15000392)~=0
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.tdfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tdfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end