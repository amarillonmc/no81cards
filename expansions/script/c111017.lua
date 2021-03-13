--巨龙人形=岩骷龙
local m = 111017
local cm = _G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	--tg 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.damcon)
	e1:SetTarget(cm.damtg)
	e1:SetOperation(cm.damop)
	c:RegisterEffect(e1)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer() ~= tp 
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsAttackPos() end
	if chk == 0 then return Duel.IsExistingTarget(Card.IsAttackPos,tp,0,LOCATION_MZONE,1,nil) and e:GetHandler():IsAttackPos() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsAttackPos,tp,0,LOCATION_MZONE,1,1,nil)
end
function cm.damop(e,tp)
	local c = e:GetHandler()
	local tc = Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not c:IsAttackPos() or not tc:IsRelateToEffect(e) or not tc:IsAttackPos() then return end
	Duel.CalculateDamage(c,tc)
	if not c:IsStatus(STATUS_BATTLE_DESTROYED) and not tc:IsStatus(STATUS_BATTLE_DESTROYED) then
		Duel.SendtoGrave(tc,REASON_RULE)
		Duel.SetLP(1-tp,math.max(Duel.GetLP(1-tp)-tc:GetAttack(),0))
	end
end