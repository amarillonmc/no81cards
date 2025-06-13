--俏丽魔发师
local s,id,o=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(s.spcost)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.filter1(c,tp,tc)
	return c:IsType(TYPE_MONSTER) and not c:IsPublic() and not c:IsCode(tc:GetCode()) and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil,tp,c,tc)
end
function s.filter2(c,tp,mc,tc)
	local g=Group.FromCards(c,mc,tc)
	return c:IsType(TYPE_MONSTER) and g:GetClassCount(Card.GetCode)==3 and g:GetClassCount(Card.GetLevel)==2 and g:GetClassCount(Card.GetRace)==2 and g:GetClassCount(Card.GetAttribute)==2
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_HAND,0,1,nil,tp,c) and not c:IsPublic() end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local pc=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_HAND,0,1,1,c,tp,c):GetFirst()
	Duel.ConfirmCards(1-tp,pc)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	pc:RegisterEffect(e1)
	local e2=e1:Clone()
	c:RegisterEffect(e2)
	e:SetLabel(pc:GetOriginalCode())
	e:SetLabelObject(pc)
	Duel.SetTargetCard(pc)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local code=e:GetLabelObject():GetOriginalCodeRule()
	if not getmetatable(tc) then code=80316585 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil,tp,c,tc)
	if g1:GetCount()==0 then return end
	Duel.ConfirmCards(1-tp,g1)
	if c:IsRelateToEffect(e) and c:IsPublic() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		c:ReplaceEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_CHAINING)
		e3:SetLabelObject(tc)
		e3:SetCondition(s.rscon)
		e3:SetOperation(s.rsop)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e5:SetCode(EVENT_ADJUST)
		e5:SetCondition(function() return not c:IsLocation(LOCATION_HAND) or not c:IsPublic() end)
		e5:SetOperation(function() if aux.GetValueType(e3)=="Effect" then e3:Reset() end end)
		e5:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e5,tp)
	end
	if tc:IsRelateToEffect(e) and tc:IsPublic() then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_CODE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(g1:GetFirst():GetOriginalCodeRule())
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local code2=g1:GetFirst():GetOriginalCode()
		if not getmetatable(g1:GetFirst()) then code2=80316585 end
		tc:ReplaceEffect(code2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CANNOT_TRIGGER)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e4:SetCondition(s.ctcon)
		tc:RegisterEffect(e4,true)
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
		if getmetatable(tc) then
			s.proeffects=s.proeffects or {}
			local _SetProperty=Effect.SetProperty
			local _CRegisterEffect=Card.RegisterEffect
			local _DRegisterEffect=Duel.RegisterEffect
			local _Clone=Effect.Clone
			Effect.SetProperty=function(pe,prop1,prop2)
				if not prop2 then prop2=0 end
				if prop1&EFFECT_FLAG_UNCOPYABLE~=0 then
					s.proeffects[pe]={prop1,prop2}
					prop1=prop1&(~EFFECT_FLAG_UNCOPYABLE)
				else
					s.proeffects[pe]=nil
					prop1=prop1&(EFFECT_FLAG_UNCOPYABLE)
				end
				return _SetProperty(pe,prop1,prop2)
			end
			Card.RegisterEffect=function(c,pe,...)
				if not pe:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) and not s.proeffects[pe] and not pe:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
				return _CRegisterEffect(c,pe,...)
			end
			Duel.RegisterEffect=function(pe,p,...)
				if not pe:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) and not s.proeffects[pe] then return end
				return _DRegisterEffect(pe,p,...)
			end
			Effect.Clone=function(pe)
				local ce=_Clone(pe)
				if s.proeffects[pe] then
					s.proeffects[ce]=s.proeffects[pe]
				end
				return ce
			end
			tc:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			Effect.SetProperty=_SetProperty
			Card.RegisterEffect=_CRegisterEffect
			Duel.RegisterEffect=_DRegisterEffect
			Effect.Clone=_Clone
			for ke,vp in pairs(s.proeffects) do
				local prop1,prop2=table.unpack(vp)
				ke:SetProperty(prop1|EFFECT_FLAG_UNCOPYABLE,prop2)
			end
		end
	end
end
function s.ctcon(e)
	return e:GetHandler():GetFlagEffect(id)>0
end
function s.rscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==re:GetHandler()
end
function s.rsop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:ResetFlagEffect(id)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetLabel(ev)
	e2:SetLabelObject(tc)
	e2:SetReset(RESET_CHAIN)
	e2:SetOperation(s.resetop)
	Duel.RegisterEffect(e2,tp)
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if ev==e:GetLabel() then tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3)) end
end