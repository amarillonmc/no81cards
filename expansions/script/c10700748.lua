--追忆于刹那芳华
function c10700748.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,10700748+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10700748.target)
	e1:SetOperation(c10700748.operation)
	c:RegisterEffect(e1)  
	--Damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(54340229,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_CONFIRM)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,10700749)
	e2:SetCondition(c10700748.damcon)
	e2:SetTarget(c10700748.damtg)
	e2:SetOperation(c10700748.damop)
	c:RegisterEffect(e2)  
end
function c10700748.filter(c)
	return c:IsSetCard(0x7cc) and c:IsAbleToDeck()
end
function c10700748.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10700748.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingTarget(c10700748.filter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c10700748.filter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10700748.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c10700748.damcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if not tc:IsControler(tp) then tc=Duel.GetAttackTarget() end
	return tc and tc:IsSetCard(0x7cc) and tc:IsAttack(0)
end
function c10700748.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ac=Duel.GetBattleMonster(tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ac:GetBaseAttack())
end
function c10700748.damop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetBattleMonster(tp)
	if not ac:IsRelateToBattle() then return end
	Duel.Damage(1-tp,ac:GetBaseAttack(),REASON_EFFECT)
end