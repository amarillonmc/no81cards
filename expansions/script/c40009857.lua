--守护天灵 雷米耶尔
local m=40009857
local cm=_G["c"..m]
cm.named_with_ProtectorSpirit=1
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),2,2,cm.lcheck)
	c:EnableReviveLimit()  
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_RECOVER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.damcon)
	e3:SetOperation(cm.damop)
	c:RegisterEffect(e3)

end
function cm.ProtectorSpirit(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ProtectorSpirit
end
function cm.lfilter(c)
	return cm.ProtectorSpirit(c)
end
function cm.lcheck(g,lc)
	return g:IsExists(cm.lfilter,1,nil)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:SetLabel(0)
	if (Duel.GetLP(e:GetHandlerPlayer())>=10000 or Duel.GetLP(1-tp)>=10000) then
		e:SetLabel(1)
		return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
	else
		return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
	end
end
function cm.thfilter(c,chk)
	return ((cm.ProtectorSpirit(c) and c:IsType(TYPE_SPELL+TYPE_TRAP)) or (chk==1 and c:IsRace(RACE_FAIRY))) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	return re and not re:GetHandler():IsCode(m)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Recover(tp,1000,REASON_EFFECT)
end





