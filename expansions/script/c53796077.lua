local m=53796077
local cm=_G["c"..m]
cm.name="批判家CB"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(aux.bfgcost)
	e3:SetCondition(cm.rmcon)
	e3:SetTarget(cm.rmtg)
	e3:SetOperation(cm.rmop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_HAND)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetOperation(cm.adjustop1)
	c:RegisterEffect(e4)
	local g1=Group.CreateGroup()
	g1:KeepAlive()
	e4:SetLabelObject(g1)
	e2:SetLabelObject(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e5:SetOperation(cm.adjustop2)
	c:RegisterEffect(e5)
	local g2=Group.CreateGroup()
	g2:KeepAlive()
	e5:SetLabelObject(g2)
	e3:SetLabelObject(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(m)
	e6:SetRange(LOCATION_HAND+LOCATION_MZONE)
	c:RegisterEffect(e6)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=e:GetLabelObject():GetLabelObject()
	if not g or #g==0 then return false end
	local rg=g:Filter(Card.IsLocation,nil,LOCATION_ONFIELD+LOCATION_GRAVE)
	return #rg>0 and Duel.GetMZoneCount(tp,rg)>0 and rg:FilterCount(Card.IsAbleToRemoveAsCost,nil)==#rg
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject():GetLabelObject()
	local rg=g:Filter(Card.IsLocation,nil,LOCATION_ONFIELD+LOCATION_GRAVE)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabelObject():GetCount()>0
end
function cm.remfilter(c)
	return c:IsAbleToRemove()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and cm.remfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(cm.remfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,e:GetHandler()) end
	local b1=Duel.IsExistingTarget(cm.remfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsExistingTarget(cm.remfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	else op=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=nil
	if op==0 then
		g=Duel.SelectTarget(tp,cm.remfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	elseif op==1 then
		g=Duel.SelectTarget(tp,cm.remfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	else
		g=Duel.SelectTarget(tp,cm.remfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	end
	local sg=e:GetLabelObject():GetLabelObject()
	if sg:IsContains(g:GetFirst()) then e:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE) else e:SetProperty(EFFECT_FLAG_CARD_TARGET) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.adjustop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	g:Clear()
	c:RegisterFlagEffect(m,0,0,0)
	local bool1=c:IsHasEffect(EFFECT_CANNOT_SPECIAL_SUMMON)
	local bool2=c:IsHasEffect(EFFECT_SPSUMMON_COST)
	local bool3=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SPECIAL_SUMMON)
	local bool4=Duel.IsPlayerAffectedByEffect(tp,EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)
	local bool5=Duel.IsPlayerAffectedByEffect(tp,EFFECT_SPSUMMON_COUNT_LIMIT)
	if not (bool1 or bool2 or bool3 or bool4 or bool5) then return end
	local re1={c:IsHasEffect(EFFECT_CANNOT_SPECIAL_SUMMON)}
	local re2={c:IsHasEffect(EFFECT_SPSUMMON_COST)}
	local re5={Duel.IsPlayerAffectedByEffect(tp,EFFECT_SPSUMMON_COUNT_LIMIT)}
	for _,te1 in pairs(re1) do
		local con=te1:GetCondition()
		if not con then con=aux.TRUE end
		g:AddCard(te1:GetOwner())
		te1:SetCondition(cm.chcon(con,0))
	end
	for _,te2 in pairs(re2) do
		if te2:GetType()==EFFECT_TYPE_SINGLE then
			local con=te2:GetCondition()
			if not con then con=aux.TRUE end
			g:AddCard(te2:GetOwner())
			te2:SetCondition(cm.chcon(con,0))
		end
		if te2:GetType()==EFFECT_TYPE_FIELD then
			local tg=te2:GetTarget()
			local o,h=te2:GetOwner(),te2:GetHandler()
			if not tg then
				if h then g:AddCard(h) else g:AddCard(o) end
				te2:SetTarget(cm.chtg(aux.TRUE,0))
			elseif tg(te2,c,tp)==true then
				if h then g:AddCard(h) else g:AddCard(o) end
				te2:SetTarget(cm.chtg(tg,0))
			end
		end
	end
	for _,te5 in pairs(re5) do
		local val=te5:GetValue()
		local _,a=te5:GetLabel()
		if a==0 then te5:SetLabel(0,val) end
		local x,o,h=nil,te5:GetOwner(),te5:GetHandler()
		if h then x=h else x=o end
		local sp=Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)
		local _,b=te5:GetLabel()
		if sp==0 then
			te5:SetLabel(1,b)
			te5:SetValue(b)
		end
		val=te5:GetValue()
		local l,_=te5:GetLabel()
		if l==0 then te5:SetLabel(sp+1,b) else
			local n=sp-l+1
			if n==val then
				te5:SetValue(val+1)
				local e1=te5:Clone()
				e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e1:SetReset(RESET_PHASE+PHASE_END)
				local loc=te5:GetRange()
				if loc~=0 then
					e1:SetLabelObject(te5)
					h:RegisterEffect(e1)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e2:SetCode(EVENT_ADJUST)
					e2:SetLabel(loc,b)
					e2:SetLabelObject(e1)
					e2:SetOperation(cm.reset1)
					Duel.RegisterEffect(e2,tp)
				else Duel.RegisterEffect(e1,te5:GetOwnerPlayer()) end
			end
		end
	end
	local re3={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SPECIAL_SUMMON)}
	local re4={Duel.IsPlayerAffectedByEffect(tp,EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)}
	for _,te3 in pairs(re3) do
		local tg=te3:GetTarget()
		local o,h=te3:GetOwner(),te3:GetHandler()
		if not tg then
			if h then g:AddCard(h) else g:AddCard(o) end
			te3:SetTarget(cm.chtg3(aux.TRUE,0))
		elseif tg(te3,c,tp,SUMMON_TYPE_SPECIAL,POS_FACEUP,tp,e)==true then
			if h then g:AddCard(h) else g:AddCard(o) end
			te3:SetTarget(cm.chtg3(tg))
		end
	end
	for _,te4 in pairs(re4) do
		local tg=te4:GetTarget()
		local o,h=te4:GetOwner(),te4:GetHandler()
		if tg(te4,c,tp,tp,POS_FACEUP)==true then
			if h then g:AddCard(h) else g:AddCard(o) end
			te4:SetTarget(cm.chtg3(tg))
		end
	end
	c:ResetFlagEffect(m)
end
function cm.adjustop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	g:Clear()
	c:RegisterFlagEffect(m+500,0,0,0)
	local bool1=c:IsHasEffect(EFFECT_CANNOT_TRIGGER)
	local bool2=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE)
	local bool3=Duel.IsPlayerAffectedByEffect(tp,EFFECT_ACTIVATE_COST)
	if not (bool1 or bool2 or bool3) then return end
	local re1={c:IsHasEffect(EFFECT_CANNOT_TRIGGER)}
	local re2={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE)}
	local re3={Duel.IsPlayerAffectedByEffect(tp,EFFECT_ACTIVATE_COST)}
	for _,te1 in pairs(re1) do
		if te1:GetType()==EFFECT_TYPE_SINGLE then
			local con=te1:GetCondition()
			if not con then con=aux.TRUE end
			g:AddCard(te1:GetOwner())
			te1:SetCondition(cm.chcon(con,500))
		end
		if te1:GetType()==EFFECT_TYPE_EQUIP then
			local con=te1:GetCondition()
			if not con then con=aux.TRUE end
			g:AddCard(te1:GetOwner())
			te1:SetCondition(cm.chcon2(con))
		end
		if te1:GetType()==EFFECT_TYPE_FIELD then
			local tg=te1:GetTarget()
			local o,h=te1:GetOwner(),te1:GetHandler()
			if not tg then
				if h then g:AddCard(h) else g:AddCard(o) end
				te1:SetTarget(cm.chtg(aux.TRUE,500))
			elseif tg(te1,c)==true then
				if h then g:AddCard(h) else g:AddCard(o) end
				te1:SetTarget(cm.chtg(tg,500))
			end
		end
	end
	for _,te2 in pairs(re2) do
		local val=te2:GetValue()
		local o,h=te2:GetOwner(),te2:GetHandler()
		if aux.GetValueType(val)=="number" then val=aux.TRUE end
		if val(te2,e,tp) then
			if h then g:AddCard(h) else g:AddCard(o) end
			te2:SetValue(cm.chval(val))
		end
	end
	for _,te3 in pairs(re3) do
		local tg=te3:GetTarget()
		local o,h=te3:GetOwner(),te3:GetHandler()
		if not tg then
			if h then g:AddCard(h) else g:AddCard(o) end
			te3:SetTarget(cm.chtg2(aux.TRUE))
		elseif tg(te3,e,tp)==true then
			if h then g:AddCard(h) else g:AddCard(o) end
			te3:SetTarget(cm.chtg2(tg))
		end
	end
	c:ResetFlagEffect(m+500)
end
function cm.chcon(_con,t)
	return function(e,...)
				local x=e:GetHandler()
				if x:IsHasEffect(m) and x:GetFlagEffect(m+t)<1 then return false end
				return _con(e,...)
			end
end
function cm.chcon2(_con)
	return function(e,...)
				local x=e:GetHandler():GetEquipTarget()
				if x:IsHasEffect(m) and x:GetFlagEffect(m+500)<1 then return false end
				return _con(e,...)
			end
end
function cm.reset1(e,tp,eg,ep,ev,re,r,rp)
	local x=e:GetLabelObject():GetHandler()
	local te=e:GetLabelObject():GetLabelObject()
	local loc,v=e:GetLabel()
	if x:GetLocation()&loc==0 then
		te:SetLabel(0,v)
		te:SetValue(v)
		e:GetLabelObject():Reset()
		e:Reset()
	end
end
function cm.chtg(_tg,t)
	return function(e,c,...)
				if c:IsHasEffect(m) and c:GetFlagEffect(m+t)<1 then return false end
				return _tg(e,c,...)
			end
end
function cm.chtg2(_tg)
	return function(e,te,...)
				local x=te:GetHandler()
				if x:IsHasEffect(m) and x:GetFlagEffect(m+500)<1 then return false end
				return _tg(e,te,...)
			end
end
function cm.chtg3(_tg)
	return function(e,c,sump,sumtype,sumpos,targetp,se)
				if c:IsHasEffect(m) and se:GetHandler()==c and c:GetFlagEffect(m)<1 then return false end
				return _tg(e,c,sump,sumtype,sumpos,targetp,se)
			end
end
function cm.chval(_val)
	return function(e,re,...)
				local x=re:GetHandler()
				if x:IsHasEffect(m) and x:GetFlagEffect(m)<1 then return false end
				return _val(e,re,...)
			end
end
