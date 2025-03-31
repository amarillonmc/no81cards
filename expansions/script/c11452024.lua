--虚诞衍律『商』
local cm,m=GetID()
function cm.initial_effect(c)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetCondition(cm.con)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
	--leave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(m)
	c:RegisterEffect(e2)
	local custom_code=cm.RegisterMergedEvent_ToSingleCard(c,m,{EVENT_LEAVE_FIELD,EVENT_LEAVE_GRAVE,EVENT_MOVE,EVENT_CUSTOM+m+1})
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(custom_code)
	e4:SetRange(0xff)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(cm.leaveop)
	c:RegisterEffect(e4)
	--[[local e5=e4:Clone()
	e5:SetCode(EVENT_LEAVE_GRAVE)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_MOVE)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EVENT_CUSTOM+m+1)
	c:RegisterEffect(e7)--]]
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.check)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetCondition(cm.clearcon)
		ge2:SetOperation(cm.clear)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge2:Clone()
		ge3:SetCode(EVENT_CHAIN_NEGATED)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge1:Clone()
		ge4:SetCode(EVENT_CHAIN_NEGATED)
		ge4:SetCondition(cm.rscon)
		ge4:SetOperation(cm.reset)
		Duel.RegisterEffect(ge4,0)
		local _Overlay=Duel.Overlay
		function Duel.Overlay(xc,v,...)
			local t=Auxiliary.GetValueType(v)
			local g=Group.CreateGroup()
			if t=="Card" then g:AddCard(v) else g=v end
			if g:IsExists(Card.IsHasEffect,1,nil,m) then
				Duel.RaiseEvent(g:Filter(Card.IsLocation,nil,LOCATION_GRAVE),EVENT_CUSTOM+m+1,e,0,0,0,0)
			end
			return _Overlay(xc,v,...)
		end
	end
end
function cm.RegisterMergedEvent_ToSingleCard(c,code,events)
	local g=Group.CreateGroup()
	g:KeepAlive()
	local mt=getmetatable(c)
	local seed=0
	if type(events) == "table" then
		for _, event in ipairs(events) do
			seed = seed + event
		end
	else
		seed = events
	end
	while(mt[seed]==true) do
		seed = seed + 1
	end
	mt[seed]=true
	local event_code_single = (code ~ (seed << 16)) | EVENT_CUSTOM
	if type(events) == "table" then
		for _, event in ipairs(events) do
			cm.RegisterMergedEvent_ToSingleCard_AddOperation(c,g,event,event_code_single)
		end
	else
		cm.RegisterMergedEvent_ToSingleCard_AddOperation(c,g,events,event_code_single)
	end
	return event_code_single
end
function cm.RegisterMergedEvent_ToSingleCard_AddOperation(c,g,event,event_code_single)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(event)
	e1:SetValue(event)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(0xff)
	e1:SetLabel(event_code_single)
	e1:SetLabelObject(g)
	e1:SetOperation(cm.MergedDelayEventCheck1_ToSingleCard)
	c:RegisterEffect(e1)
	--[[local _GetCode=Effect.GetCode
	function Effect.GetCode(e,...)
		return _GetCode(e,...)==event_code_single and event or _GetCode(e,...)
	end--]]
	local ec={
		EVENT_CHAIN_ACTIVATING,
		EVENT_CHAINING,
		EVENT_ATTACK_ANNOUNCE,
		EVENT_BREAK_EFFECT,
		EVENT_CHAIN_SOLVING,
		EVENT_CHAIN_SOLVED,
		EVENT_CHAIN_END,
		EVENT_SUMMON,
		EVENT_SPSUMMON,
		EVENT_MSET,
		EVENT_BATTLE_DESTROYED
	}
	for _,code in ipairs(ec) do
		local ce=e1:Clone()
		ce:SetCode(code)
		ce:SetOperation(cm.MergedDelayEventCheck2_ToSingleCard)
		c:RegisterEffect(ce)
	end
end
function cm.MergedDelayEventCheck1_ToSingleCard(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local c=e:GetOwner()
	g:Merge(eg)
	if Duel.GetCurrentChain()==0 and #g>0 then
		local _eg=g:Clone()
		if g:IsContains(c) and (c:IsFaceup() or c:IsPreviousPosition(POS_FACEUP)) then 
			if e:GetValue()==EVENT_MOVE then
				local loc=0
				if c:GetPreviousLocation()&LOCATION_ONFIELD>0 then
					loc=LOCATION_GRAVE
				elseif c:GetPreviousLocation()&LOCATION_GRAVE>0 then
					loc=LOCATION_ONFIELD
				end
				_eg=_eg:Filter(Card.IsPreviousLocation,nil,loc)
			end
			if #_eg>0 then Duel.RaiseEvent(_eg,e:GetLabel(),re,r,rp,ep,ev) end
		end
		g:Clear()
	end
end
function cm.MergedDelayEventCheck2_ToSingleCard(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local c=e:GetOwner()
	if #g>0 then
		local _eg=g:Clone()
		if g:IsContains(c) and (c:IsFaceup() or c:IsPreviousPosition(POS_FACEUP)) then 
			if e:GetValue()==EVENT_MOVE then
				local loc=0
				if c:GetPreviousLocation()&LOCATION_ONFIELD>0 then
					loc=LOCATION_GRAVE
				elseif c:GetPreviousLocation()&LOCATION_GRAVE>0 then
					loc=LOCATION_ONFIELD
				end
				_eg=_eg:Filter(Card.IsPreviousLocation,nil,loc)
			end
			if #_eg>0 then Duel.RaiseEvent(_eg,e:GetLabel(),re,r,rp,ep,ev) end
		end
		g:Clear()
	end
end
function cm.check(e,tp,eg,ep,ev,re,r,rp)
	local tf=re:GetHandler():IsRelateToEffect(re)
	local cid=re:GetHandler():GetRealFieldID()
	cm[ev]={re,tf,cid}
end
function cm.rscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>1
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	cm[ev]={re,false,0}
end
function cm.clearcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	local i=1
	while cm[i] do
		cm[i]=nil
		i=i+1
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local loc,pos=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_POSITION)
	return loc&LOCATION_HAND>0 and ((re:GetHandler():IsLocation(LOCATION_HAND) and re:GetHandler():IsPublic()) or pos&POS_FACEUP>0)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Group.CreateGroup()
		local g1=Group.CreateGroup()
		local g2=Group.CreateGroup()
		for i=1,Duel.GetCurrentChain() do
			local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			local tc=te:GetHandler()
			if tc:IsRelateToEffect(te) and tc:IsAbleToHand() and tc:IsOnField() then g:AddCard(tc) end
			if tc:IsRelateToEffect(te) and tc:IsLocation(LOCATION_HAND) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and tc:IsControler(tp) then g1:AddCard(tc) end
			if tc:IsRelateToEffect(te) and tc:IsLocation(LOCATION_HAND) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and tc:IsControler(1-tp) then g2:AddCard(tc) end
		end
		return #(g+g1+g2)>0 and (#g1<=0 or Duel.GetMZoneCount(tp,g)>0) and (#g2<=0 or Duel.GetMZoneCount(1-tp,g,tp)>0) and (#(g1+g2)<=1 or not Duel.IsPlayerAffectedByEffect(tp,59822133))
	end
	local g=Group.CreateGroup()
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	for i=1,Duel.GetCurrentChain() do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		if tc:IsRelateToEffect(te) and tc:IsAbleToHand() and tc:IsOnField() then g:AddCard(tc) end
		if tc:IsRelateToEffect(te) and tc:IsLocation(LOCATION_HAND) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and tc:IsControler(tp) then g1:AddCard(tc) end
		if tc:IsRelateToEffect(te) and tc:IsLocation(LOCATION_HAND) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and tc:IsControler(1-tp) then g2:AddCard(tc) end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1+g2,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	local i=1
	while type(cm[i])=="table" do
		local te,tf,cid=table.unpack(cm[i])
		local tc=te:GetHandler()
		if ((i<=Duel.GetCurrentChain() and tc:IsRelateToEffect(te)) or (i>Duel.GetCurrentChain() and tf and tc:GetRealFieldID()==cid)) then
			if tc:IsAbleToHand() and tc:IsOnField() then g:AddCard(tc) end
			if tc:IsLocation(LOCATION_HAND) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and tc:IsControler(tp) then g1:AddCard(tc) end
			if tc:IsLocation(LOCATION_HAND) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and tc:IsControler(1-tp) then g2:AddCard(tc) end
		end   
		i=i+1
	end
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
	local thg=Group.CreateGroup()
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
	if #(g1+g2)==0 or (#(g1+g2)>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
	if #g1<=ft1 then
		for tc in aux.Next(g1) do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g1:Select(tp,ft1,ft1,nil)
		for tc in aux.Next(sg) do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		end
		g1:Sub(sg)
		thg:Merge(g1)
	end
	if #g2<=ft2 then
		for tc in aux.Next(g2) do
			Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g2:Select(tp,ft2,ft2,nil)
		for tc in aux.Next(sg) do
			Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP)
		end
		g2:Sub(sg)
		thg:Merge(g2)
	end
	Duel.SpecialSummonComplete()
	Duel.SendtoGrave(thg,REASON_RULE)
end
function cm.leaveop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not eg:IsContains(c) then return end
	local g=eg:Clone()
	if c:IsFacedown() and c:IsPreviousPosition(POS_FACEDOWN) then return end
	Duel.Hint(HINT_CARD,0,m)
	for tc in aux.Next(g) do
		if tc:IsPreviousPosition(POS_FACEUP) then
			local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
			e1:SetTarget(cm.distg1)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_SOLVING)
			e2:SetCondition(cm.discon)
			e2:SetOperation(cm.disop)
			e2:SetLabelObject(tc)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e3:SetTarget(cm.distg2)
			e3:SetLabelObject(tc)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function cm.distg1(e,c)
	local tc=e:GetLabelObject()
	if c:IsType(TYPE_SPELL+TYPE_TRAP) then
		return c:IsCode(tc:GetCode())
	else
		return c:IsCode(tc:GetCode()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
	end
end
function cm.distg2(e,c)
	local tc=e:GetLabelObject()
	return c:IsCode(tc:GetCode())
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsCode(tc:GetCode())
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end