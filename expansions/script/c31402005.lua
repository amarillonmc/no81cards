local m=31402005
local cm=_G["c"..m]
cm.name="时计塔的引导-不思议之泣"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.wincon)
	e1:SetOperation(cm.winop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(cm.searcon)
	e3:SetTarget(cm.seartg)
	e3:SetOperation(cm.searop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(cm.aclimit)
	e4:SetCondition(cm.actcon)
	c:RegisterEffect(e4)
end
function cm.winfilter(c)
	local res=0
	if c:IsSetCard(0x5311) and c:IsType(TYPE_MONSTER) then
		res=1
	end
	return res
end
function cm.check(g)
	return g:GetCount()==6 and g:GetClassCount(Card.GetCode)==6 and g:GetSum(cm.winfilter)==6
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
function cm.searcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function cm.searfilter(c)
	return c:IsSetCard(0x5311) and c:IsAbleToHand()
end
function cm.seartg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.searfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.searop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.searfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.aclimit(e,re,tp)
	return true
end
function cm.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end