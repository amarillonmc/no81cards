local m=15000244
local cm=_G["c"..m]
cm.name="记忆：永寂之国"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,15000244)
	--activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1) 
	--swith
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(cm.sw1con)
	e2:SetTarget(cm.sw1tg)
	e2:SetOperation(cm.sw1op)
	c:RegisterEffect(e2)
	--swith
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_ATKCHANGE)  
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCondition(cm.sw2con)
	e3:SetTarget(cm.sw2tg)
	e3:SetOperation(cm.sw2op)
	c:RegisterEffect(e3)
end
function cm.swfilter01(c)  
	return c:IsFaceup() and c:IsCode(15000240) 
end
function cm.swfilter02(c)  
	return c:IsFaceup() and c:IsCode(15000241) 
end
function cm.swfilter1(c)  
	return c:IsFacedown() and c:GetSequence()<5  
end
function cm.swfilter2(c)  
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function cm.sw1con(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.swfilter01,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function cm.sw2con(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.swfilter02,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function cm.sw1tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()  
	local tp=c:GetControler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.swfilter1,tp,0,LOCATION_SZONE,1,e:GetHandler()) end
end
function cm.sw2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()  
	local tp=c:GetControler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.swfilter2,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
end
function cm.sw1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,cm.swfilter1,tp,0,LOCATION_SZONE,1,1,e:GetHandler()):GetFirst()
	if tc:IsFacedown() then
		Duel.HintSelection(Group.FromCards(tc))
		e:SetLabelObject(tc)
		local fid=tc:GetFieldID()
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(m,1))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DRAW)
		e1:SetLabelObject(tc)
		e1:SetCondition(cm.relcon)
		tc:RegisterEffect(e1)
		--End of e1
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DRAW)
		e2:SetLabel(fid)
		e2:SetLabelObject(e1)
		e2:SetCondition(cm.endcon)
		e2:SetOperation(cm.endop)
		Duel.RegisterEffect(e2,tp)
		--send to grave
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DRAW)
		e3:SetLabel(fid)
		e3:SetLabelObject(tc)
		e3:SetCondition(cm.tgcon)
		e3:SetOperation(cm.tgop)
		Duel.RegisterEffect(e3,1-tp)
		--activate check
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetCode(EVENT_CHAINING)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DRAW)
		e4:SetLabel(fid)
		e4:SetLabelObject(e3)
		e4:SetCondition(cm.rstcon)
		e4:SetOperation(cm.rstop)
		Duel.RegisterEffect(e4,tp)
	end
end
function cm.relcon(e)
	return e:GetHandler():GetFlagEffect(m)~=0
end
function cm.endcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject():GetLabelObject()
	if tc:GetFlagEffectLabel(m)==e:GetLabel() then
		return not c:IsDisabled()
	else
		e:Reset()
		return false
	end
end
function cm.endop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	te:Reset()
	Duel.HintSelection(Group.FromCards(e:GetHandler()))
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(m)==e:GetLabel() then
		return not c:IsDisabled()
	else
		e:Reset()
		return false
	end
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoGrave(tc,REASON_RULE)
end
function cm.rstcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	return tc:GetFlagEffectLabel(m)==e:GetLabel()
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	tc:ResetFlagEffect(m)
	local te=e:GetLabelObject()
	if te then te:Reset() end
end
function cm.sw2op(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.swfilter2,tp,0,LOCATION_MZONE,nil)  
	local tc=g:GetFirst()  
	while tc do  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)  
		e1:SetValue(tc:GetBaseAttack()/2)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e1)  
		tc=g:GetNext()  
	end
end