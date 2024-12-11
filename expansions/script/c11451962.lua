--秘计螺旋 寒流
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--Set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CUSTOM+11451961)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(0xff)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
	if not DEFECT_ORAL_CHECK then
		DEFECT_ORAL_CHECK=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(cm.resetop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CUSTOM+11451961)
		ge2:SetOperation(cm.evop)
		Duel.RegisterEffect(ge2,0)
	end
	if not PNFL_IMMUNE_CHECK then
		PNFL_IMMUNE_CHECK=true
		local _IsImmuneToEffect=Card.IsImmuneToEffect
		function Card.IsImmuneToEffect(c,...)
			c:RegisterFlagEffect(11451965,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
			local res=_IsImmuneToEffect(c,...)
			c:ResetFlagEffect(11451965)
			return res
		end
	end
end
function cm.resetop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(function(c) return c:IsFacedown() and c:GetFlagEffect(11451961)>0 end,0,0xff,0xff,nil)+Duel.GetOverlayGroup(0,1,1):Filter(function(c) return c:GetFlagEffect(11451961)>0 end,nil)
	local g2=Duel.GetMatchingGroup(function(c) return c:IsFacedown() and c:GetFlagEffect(11451962)>0 end,0,0xff,0xff,nil)+Duel.GetOverlayGroup(0,1,1):Filter(function(c) return c:GetFlagEffect(11451962)>0 end,nil)
	for tc in aux.Next(g1) do tc:ResetFlagEffect(11451961) end
	for tc in aux.Next(g2) do tc:ResetFlagEffect(11451962) end
end
function cm.evop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if Duel.GetCurrentChain()==0 then Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+11451961,re,0,0,0,0) return end
	local ge2=Effect.CreateEffect(e:GetHandler())
	ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge2:SetCode(EVENT_CHAIN_END)
	ge2:SetOperation(function(e) Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+11451961,re,0,0,0,0) e:Reset() end)
	Duel.RegisterEffect(ge2,0)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	c:RegisterFlagEffect(11451962,RESET_EVENT+RESET_TODECK+RESET_TOHAND+RESET_TURN_SET+RESET_OVERLAY+RESET_CHAIN,EFFECT_FLAG_OATH,1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,m)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(cm.recon)
	e1:SetOperation(cm.reop)
	Duel.RegisterEffect(e1,tp)
	local eid=e1:GetFieldID()
	e1:SetLabel(eid)
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451961)}
	DEFECT_ORAL_COUNT=DEFECT_ORAL_COUNT or 3
	if #eset==DEFECT_ORAL_COUNT then
		local de=eset[1]
		local ce=de:GetLabelObject()
		if ce and aux.GetValueType(ce)=="Effect" then
			local tc=ce:GetHandler()
			local eset2={tc:IsHasEffect(EFFECT_FLAG_EFFECT+11451961)}
			local res=false
			for _,te in pairs(eset2) do
				if te:GetLabel()==de:GetLabel() then res=true break end
			end
			if res then
				Duel.RaiseEvent(tc,EVENT_CUSTOM+11451961,e,0,0,0,0)
				Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(tc:GetOriginalCode(),3))
				Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(tc:GetOriginalCode(),3))
			end
			ce:Reset()
		end
		de:Reset()
		eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451961)}
		for _,te in pairs(eset) do
			local te2=te:Clone()
			te2:SetDescription(te:GetDescription()-16)
			Duel.RegisterEffect(te2,tp)
			local ce=te:GetLabelObject()
			if ce and aux.GetValueType(ce)=="Effect" then
				local tc=ce:GetHandler()
				local ce2=ce:Clone()
				ce2:SetDescription(ce:GetDescription()-16)
				tc:RegisterEffect(ce2,true)
				te2:SetLabelObject(ce2)
				ce:Reset()
			end
			te:Reset()
		end
	end
	local ce=nil
	eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451961)}
	if c:GetFlagEffect(11451962)>0 or (c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED) and not e:IsHasType(EFFECT_TYPE_ACTIVATE)) then
		ce=c:RegisterFlagEffect(11451961,RESET_EVENT+RESET_TODECK+RESET_TOHAND+RESET_TURN_SET+RESET_OVERLAY,EFFECT_FLAG_CLIENT_HINT,1,eid,aux.Stringid(11451961+#eset,1))
	end
	local de=Effect.CreateEffect(c)
	de:SetDescription(aux.Stringid(11451961+#eset,6))
	de:SetLabel(eid)
	de:SetType(EFFECT_TYPE_FIELD)
	de:SetCode(0x20000000+11451961)
	de:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	de:SetTargetRange(1,0)
	Duel.RegisterEffect(de,tp)
	if ce and aux.GetValueType(ce)=="Effect" then de:SetLabelObject(ce) end
end
function cm.recon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
local KOISHI_CHECK=false
if Duel.DisableActionCheck then KOISHI_CHECK=true end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451961)}
	local res=false
	for _,te in pairs(eset) do
		if te:GetLabel()==e:GetLabel() then res=true break end
	end
	if not res then e:Reset() return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
	if #g>0 then
		--Duel.HintSelection(g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,4))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		--e1:SetCondition(cm.recon)
		e1:SetValue(cm.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		g:GetFirst():RegisterEffect(e1,true)
		local eid=e1:GetFieldID()
		e1:SetLabel(eid)
		g:GetFirst():RegisterFlagEffect(m+0xffffff,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,4))
	end
end
function cm.efilter(e,te)
	if e:GetHandler():GetFlagEffect(m+0xffffff)>0 and te and te:GetHandler() and not te:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) and (te:GetCode()<0x10000 or te:IsHasType(EFFECT_TYPE_ACTIONS)) and te:GetCode()~=16 and te:GetCode()~=359 then
		if KOISHI_CHECK then
			Duel.DisableActionCheck(true)
			pcall(Duel.HintSelection,Group.FromCards(e:GetHandler()))
			local tc=te:GetHandler()
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(m)
			e1:SetOperation(function() pcall(Duel.Draw,te:GetHandlerPlayer(),1,REASON_EFFECT) e1:Reset() end)
			Duel.RegisterEffect(e1,0)
			pcall(Duel.RaiseEvent,tc,m,e,0,0,0,0)
			e1:Reset()
			Duel.DisableActionCheck(false)
		else
			local e5=Effect.CreateEffect(te:GetHandler())
			e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e5:SetCode(EVENT_ADJUST)
			e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e5:SetLabel(te:GetHandlerPlayer())
			e5:SetCondition(function() return not pnfl_adjusting end)
			e5:SetOperation(cm.acop)
			Duel.RegisterEffect(e5,tp)
		end
		if e:GetHandler():GetFlagEffect(11451965)>0 then
			e:SetLabelObject(te)
			e:SetLabel(Duel.GetCurrentChain())
			e:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN)
		end
		e:GetHandler():ResetFlagEffect(m+0xffffff)
		e:SetValue(function(e,te) return e:GetLabelObject() and te==e:GetLabelObject() and e:GetLabel()==Duel.GetCurrentChain() end)
		e:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e:SetDescription(0)
		return true
	end
	return false
end
function cm.filter1(c,fid)
	return c:GetFlagEffect(m)>0 and c:GetFlagEffectLabel(m)==fid
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	if pnfl_adjusting then return end
	pnfl_adjusting=true
	Duel.Draw(e:GetLabel(),1,REASON_EFFECT)
	pnfl_adjusting=false
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	if c:IsLocation(LOCATION_GRAVE) then Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)>0 and c:IsLocation(LOCATION_SZONE) then
		Duel.Draw(tp,1,REASON_EFFECT)
		--[[local cid=c:GetFieldID()
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,cid,aux.Stringid(m,4))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetTargetRange(LOCATION_SZONE,0)
		e1:SetLabel(cid)
		e1:SetCondition(cm.con)
		e1:SetValue(cm.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		Duel.RegisterEffect(e1,tp)--]]
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	if not (e:GetHandler():GetFlagEffect(m)>0 and e:GetHandler():GetFlagEffectLabel(m)==e:GetLabel() and e:GetHandler():IsFacedown()) then e:SetLabel(0) return false end
	return true
end