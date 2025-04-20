--被封印的艾克佐迪亚-EX
function c98942060.initial_effect(c)
	--win
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetOperation(c98942060.operation)
	c:RegisterEffect(e1)
end
function c98942060.filter(c)
	return c:IsCode(98942061,98942062,98942063,98942064,98942060)
end
function c98942060.check(g)
	local a1=false
	local a2=false
	local a3=false
	local a4=false
	local a5=false
	local tc=g:GetFirst()
	while tc do
		local code=tc:GetCode()
		if code==98942061 then a1=true
		elseif code==98942062 then a2=true
		elseif code==98942063 then a3=true
		elseif code==98942064 then a4=true
		elseif code==98942060 then a5=true
		end
		tc=g:GetNext()
	end
	return a1 and a2 and a3 and a4 and a5
end
function c98942060.operation(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_EXODIA = 0x10
	local g1=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0):Filter(c98942060.filter,nil)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA):Filter(c98942060.filter,nil)
	local wtp=c98942060.check(g1)
	local wntp=c98942060.check(g2)
	if wtp and not wntp then
		Duel.ConfirmCards(1-tp,g1)
		Duel.Win(tp,WIN_REASON_EXODIA)
	elseif not wtp and wntp then
		Duel.ConfirmCards(tp,g2)
		Duel.Win(1-tp,WIN_REASON_EXODIA)
	elseif wtp and wntp then
		Duel.ConfirmCards(1-tp,g1)
		Duel.ConfirmCards(tp,g2)
		Duel.Win(PLAYER_NONE,WIN_REASON_EXODIA)
	end
end
