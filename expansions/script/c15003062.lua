local m=15003062
local cm=_G["c"..m]
cm.name="特殊模式-模仿者"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e2:SetRange(LOCATION_DECK+LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCountLimit(1,15003062+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(cm.lmcon)
	e2:SetOperation(cm.lmop)
	c:RegisterEffect(e2)
end
function cm.lmcon(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return not c:IsPublic()
end
function cm.filter(c)
	return c:IsCode(15003062) and not c:IsPublic()
end
function cm.lmop(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	Duel.ConfirmCards(1-tp,c)
	Duel.ConfirmCards(tp,c)
	if Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_DECK+LOCATION_HAND,1,nil) and Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then
		local tc=Duel.GetFirstMatchingCard(cm.filter,tp,0,LOCATION_DECK+LOCATION_HAND,nil)
		Duel.ConfirmCards(1-tp,tc)
		Duel.ConfirmCards(tp,tc)
		local g=Duel.GetFieldGroup(tp,0xff,0xff)
		local ec=g:GetFirst()
		while ec do
			Duel.Exile(ec,0)
			ec=g:GetNext()
		end
		local x=0
		local y=0
		while x<40 do
			local token=Duel.CreateToken(tp,15000211)
			Duel.SendtoDeck(token,nil,0,0)
			x=x+1
		end
		while y<40 do
			local token=Duel.CreateToken(1-tp,15000211)
			Duel.SendtoDeck(token,nil,0,0)
			y=y+1
		end
		Duel.BreakEffect()
		Duel.ShuffleDeck(tp)
		Duel.ShuffleDeck(1-tp)
		local ht1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		if ht1<5 then
			Duel.Draw(tp,5-ht1,0)
		end
		local ht2=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
		if ht2<5 then
			Duel.Draw(1-tp,5-ht2,0)
		end
	end
end