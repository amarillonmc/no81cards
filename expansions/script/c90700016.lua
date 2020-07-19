local m=90700016
local cm=_G["c"..m]
cm.name="钟楼使徒 雷诺亚"
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
	e1:SetDescription(aux.Stringid(m,15))
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_DECK)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_CHANGE_RSCALE)
	e3:SetValue(7)
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
function cm.disactfilter(c)
	return aux.IsCodeListed(c,90700019) and (c:IsPreviousLocation(LOCATION_DECK) or (c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)))
end
function cm.actfilter(c)
	return c:IsPublic() and c:IsCode(m)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)>0 then
		return
	end
	if not re then
		return
	end
	if not (eg:Filter(cm.disactfilter,nil):GetCount()>0) then
		return
	end
	if not e:GetHandler():IsAbleToHandAsCost() then
		return
	end
	if Duel.GetFieldGroup(tp,LOCATION_HAND,0):FilterCount(cm.actfilter,nil)>0 then
		return
	end
	local txtnum=0
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_DECK) then
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
		if Duel.SelectYesNo(tp,aux.Stringid(m,14)) then
			local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
			Duel.Hint(HINT_MESSAGE,tp,e:GetDescription())
			Duel.ConfirmCards(tp,g:Filter(Card.IsPublic,nil))
			local tpsg=g:Select(tp,1,g:GetCount()-1,c)
			local maxnum=tpsg:GetCount()-tpsg:FilterCount(Card.IsPublic,nil)
			local handnum=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
			if maxnum>handnum then
				maxnum=handnum
			end
			local psg=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0):Select(1-tp,maxnum,maxnum,nil)
			Duel.SendtoDeck(tpsg,nil,2,REASON_EFFECT)
			Duel.SendtoDeck(psg,nil,2,REASON_EFFECT)
		end
	end
end
function cm.disresop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,m)
	e:Reset()
end
function cm.actcon(e)
	return e:GetHandler():IsPublic()
end