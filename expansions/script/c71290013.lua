--幻惑影蝶 芙拉薇娅
Duel.LoadScript("c60010000.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	MTC.StrinovaPUS(c)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(cm.immcon)
	e3:SetTarget(cm.immdtg)
	e3:SetValue(cm.immval)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(cm.desop)
	c:RegisterEffect(e5)
	
	MTC.StrinovaChangeZone(c,cm.czop)
end
function cm.immcon(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.immdtg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_SPIRIT)
end
function cm.immval(e,te_or_c)
	local res=aux.GetValueType(te_or_c)~="Effect" or (te_or_c:IsActivated() and te_or_c:GetOwner()~=e:GetHandler())
	if res then
		if aux.GetValueType(te_or_c)=="Effect" then Duel.Hint(HINT_CARD,0,m) end
		local c=e:GetHandler()
		Duel.RegisterFlagEffect(tp,m,0,0,1)
	end
	return res
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,m)~=0 then
		Duel.ResetFlagEffect(tp,m)
		Duel.Hint(HINT_CARD,0,m) 
		if c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CHANGE_DAMAGE)
			e1:SetRange(LOCATION_SZONE)
			e1:SetTargetRange(1,0)
			e1:SetValue(cm.damval)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e2:SetRange(0xff)
			e2:SetOperation(cm.rop)
			c:RegisterEffect(e2)
		else
			Duel.SendtoGrave(c,REASON_RULE)
		end
	end
end
function cm.damval(e,re,val,r,rp,rc)
	if val>800 then return 800 end
	return val
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_SZONE) and c:IsFaceup() then
		Duel.Destroy(c,REASON_EFFECT)
	end
	e:Reset()
end
function cm.czfil(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.czop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.czfil,tp,0,LOCATION_SZONE,nil)
	if #g~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=Duel.SelectMatchingCard(tp,cm.czfil,tp,0,LOCATION_SZONE,1,1,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	else
		Duel.Damage(1-tp,800,REASON_EFFECT)
	end
end









