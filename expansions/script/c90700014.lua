local m=90700014
local cm=_G["c"..m]
cm.name="钟楼使徒 纳姆卡里"
function cm.initial_effect(c)
	aux.AddCodeList(c,90700019)
	aux.EnablePendulumAttribute(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ADJUST)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(cm.wincon)
	e0:SetOperation(cm.winop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_DECK)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_HAND)
	e2:SetTargetRange(1,0)
	e2:SetCondition(cm.actcon)
	e2:SetValue(cm.actlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_CHANGE_LSCALE)
	e3:SetValue(5)
	c:RegisterEffect(e3)
end
function cm.winfilter(c)
	return aux.IsCodeListed(c,90700019) and c:IsType(TYPE_MONSTER)
end
function cm.check(g)
	return g:Filter(cm.winfilter,nil):GetClassCount(Card.GetAttribute)==6
end
function cm.wincon(e,tp,eg,ep,ev,re,r,rp)
	return cm.check(Duel.GetFieldGroup(tp,LOCATION_HAND,0)) or cm.check(Duel.GetFieldGroup(tp,0,LOCATION_HAND))
end
function cm.winop(e,tp,eg,ep,ev,re,r,rp)
	local winmessage = 0x60
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local wtp=cm.check(g1)
	local wntp=cm.check(g2)
	if wtp and not wntp then
		Duel.ConfirmCards(1-tp,g1)
		Duel.Win(tp,winmessage)
	elseif not wtp and wntp then
		Duel.ConfirmCards(tp,g2)
		Duel.Win(1-tp,winmessage)
	elseif wtp and wntp then
		Duel.ConfirmCards(1-tp,g1)
		Duel.ConfirmCards(tp,g2)
		Duel.Win(PLAYER_NONE,winmessage)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)>0 then
		return
	end
	if not re:IsActiveType(TYPE_MONSTER) then
		return
	end
	if not e:GetHandler():IsAbleToHandAsCost() then
		return
	end
	if not Duel.IsPlayerCanDraw(re:GetHandlerPlayer(),1) then
		return
	end
	local txtnum=0
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_DECK) then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=1 then
			return
		end
	elseif c:IsLocation(LOCATION_MZONE) then
		if not c:IsPosition(POS_FACEUP) then
			return
		end
		txtnum=1+c:GetSequence()
	elseif c:IsLocation(LOCATION_FZONE) then
		if not c:IsPosition(POS_FACEUP) then
			return
		end
		txtnum=13
	elseif c:IsLocation(LOCATION_SZONE) then
		if not c:IsPosition(POS_FACEUP) then
			return
		end
		txtnum=1+7+c:GetSequence()
	end
	if Duel.SelectYesNo(tp,aux.Stringid(m,txtnum)) then
		Duel.RegisterFlagEffect(tp,m,RESET_EVENT+RESET_CHAIN,0,1)
		Duel.SendtoHand(c,nil,REASON_COST)
		if txtnum==0 and c:IsLocation(LOCATION_HAND) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end
		Duel.BreakEffect()
		Duel.Draw(re:GetHandlerPlayer(),1,REASON_EFFECT)
		Duel.NegateEffect(ev)
		local rc=re:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_CHAIN_SOLVED)
		e3:SetOperation(cm.disresop)
		Duel.RegisterEffect(e3,tp)
	end
end
function cm.disresop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,m)
	e:Reset()
end
function cm.actcon(e)
	return e:GetHandler():IsPublic()
end
function cm.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end