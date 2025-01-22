--方舟骑士-柏喙
local cm,m=GetID()
cm.named_with_Arknight=1
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2)
	c:EnableReviveLimit()
	--instant(chain)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e4:SetTarget(cm.target3)
	e4:SetOperation(cm.activate3)
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		local _MoveToField=Duel.MoveToField
		local _ReturnToField=Duel.ReturnToField
		local _IsCanOverlay=Card.IsCanOverlay
		local _Overlay=Duel.Overlay
		local _Equip=Duel.Equip
		function Duel.MoveToField(c,tp,...)
			if c:IsLocation(0xf3) and c:IsHasEffect(m) then
				return false
			end
			return _MoveToField(c,tp,...)
		end
		function Duel.ReturnToField(c,...)
			local tp=c:GetPreviousControler()
			if c:IsHasEffect(m) then
				return false
			end
			return _ReturnToField(c,...)
		end
		function Card.IsCanOverlay(c,...)
			local tp=c:GetPreviousControler()
			if c:IsLocation(0xf3) and c:IsHasEffect(m) then
				return false
			end
			return _IsCanOverlay(c,...)
		end
		function Duel.Overlay(xc,v,...)
			local t=Auxiliary.GetValueType(v)
			local g=Group.CreateGroup()
			if t=="Card" then g:AddCard(v) else g=v end
			for c in aux.Next(g) do
				local tp=c:GetPreviousControler()
				if c:IsLocation(0xf3) and c:IsHasEffect(m) then
					g:RemoveCard(c)
				end
			end
			return _Overlay(xc,g,...)
		end
		function Duel.Equip(tp,c,mc,...)
			if c:IsLocation(0xf3) and c:IsHasEffect(m) then
				return false
			end
			return _Equip(tp,c,mc,...)
		end
	end
end
function cm.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local eset={c:IsHasEffect(EFFECT_FLAG_EFFECT+m)}
	local b={true,true,true}
	if #eset>0 then b[eset[#eset]:GetLabel()]=false end
	if #eset>1 then b[eset[#eset-1]:GetLabel()]=false end
	local opt=aux.SelectFromOptions(tp,{b[1],aux.Stringid(m,0)},{b[2],aux.Stringid(m,1)},{b[3],aux.Stringid(m,2)})
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,opt)
	Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(m,opt-1))
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,opt-1))
	e:SetLabel(opt)
end
function cm.activate3(e,tp,eg,ep,ev,re,r,rp)
	local val=e:GetLabel()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetOperation(cm.ctop)
	e1:SetLabel(ev)
	e1:SetValue(val)
	e1:Reset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	if ev~=e:GetLabel() then return end
	local val=e:GetValue()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetLabelObject(re)
	if val==1 then
		e1:SetCode(EVENT_TO_HAND)
		e1:SetOperation(cm.thop)
	elseif val==2 then
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetOperation(cm.spop)
	elseif val==3 then
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e1:SetTarget(cm.rmtarget)
		e1:SetTargetRange(0xff,0xff)
		e1:SetValue(LOCATION_REMOVED)
	end
	e1:Reset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetCountLimit(1)
	e2:SetLabelObject(e1)
	e2:SetOperation(cm.rsop)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
	e:Reset()
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():Reset()
end
function cm.filter1(c,re)
	return c:IsLocation(LOCATION_HAND) and c:IsType(TYPE_MONSTER) and c:IsReason(REASON_EFFECT) and (c:IsPublic() or (not c:IsStatus(STATUS_TO_HAND_WITHOUT_CONFIRM) and (c:IsPreviousLocation(LOCATION_DECK) or c:IsPreviousPosition(POS_FACEUP)))) and c:GetReasonEffect()==re
end
function cm.filter2(c,re)
	return c:IsLocation(LOCATION_MZONE) and c:GetReasonEffect()==re
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.filter1,nil,e:GetLabelObject())
	for tc in aux.Next(g) do
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(m,0))
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		local e4=e2:Clone()
		e4:SetCode(EFFECT_CANNOT_SUMMON)
		tc:RegisterEffect(e4,true)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CANNOT_MSET)
		tc:RegisterEffect(e3,true)
		local e6=e2:Clone()
		e6:SetCode(m)
		tc:RegisterEffect(e6,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetRange(LOCATION_HAND)
		e1:SetTargetRange(1,1)
		e1:SetValue(function(e,te,tp) return te:GetHandler()==e:GetHandler() and te:IsHasType(EFFECT_TYPE_ACTIVATE) end)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
	end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.filter2,nil,e:GetLabelObject())
	for tc in aux.Next(g) do
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(m,1))
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_TRIGGER)
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
	end
end
function cm.rmtarget(e,c)
	return not c:IsLocation(0x80) and not c:IsType(TYPE_SPELL+TYPE_TRAP) and c:GetReasonEffect()==e:GetLabelObject()
end