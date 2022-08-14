local m=53796057
local cm=_G["c"..m]
cm.name="可爱的怪物"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e2:SetCondition(cm.cfcon)
	e2:SetOperation(cm.cfop)
	c:RegisterEffect(e2)
end
function cm.cfcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>1
end
function cm.cfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<2 or Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)<2 then return end
	Duel.ShuffleDeck(tp)
	Duel.ShuffleDeck(1-tp)
	for i,p in ipairs({tp,1-tp}) do
		if Duel.SelectYesNo(p,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_CARDTYPE)
			local opt=Duel.AnnounceType(p)
			Duel.ConfirmDecktop(1-p,1)
			local tc=Duel.GetDecktopGroup(1-p,1):GetFirst()
			if (opt==0 and tc:IsType(TYPE_MONSTER)) or (opt==1 and tc:IsType(TYPE_SPELL)) or (opt==2 and tc:IsType(TYPE_TRAP)) then
				if Duel.GetFieldGroupCount(p,0,LOCATION_HAND)>0 then
					local g=Duel.GetFieldGroup(p,0,LOCATION_HAND):RandomSelect(p,1)
					Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
				end
			else
				Duel.SendtoHand(tc,1-p,REASON_EFFECT)
				Duel.ShuffleHand(1-p)
			end
		end
	end
end
