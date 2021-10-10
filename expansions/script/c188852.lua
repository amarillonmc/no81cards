--怪物·幻翼
function c188852.initial_effect(c)
	--Search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(188852,0))
	e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetHintTiming(TIMING_MAIN_END+TIMING_BATTLE_PHASE,TIMING_BATTLE_PHASE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c188852.damcon)
	e3:SetTarget(c188852.damtg)
	e3:SetOperation(c188852.damop)
	c:RegisterEffect(e3)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(188852,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,188852)
	e2:SetCondition(c188852.tgcon)
	e2:SetTarget(c188852.tgtg)
	e2:SetOperation(c188852.tgop)
	c:RegisterEffect(e2)
end
function c188852.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local des=eg:GetFirst()
	if des:IsReason(REASON_BATTLE) then
		local rc=des:GetReasonCard()
		return rc and rc:IsLevelAbove(5) and rc:IsAttribute(ATTRIBUTE_FIRE) and rc:IsControler(tp) and rc:IsRelateToBattle()
	end
	return false
end
function c188852.filter(c)
	return c:IsSetCard(0x16) and c:IsAbleToGrave()
end
function c188852.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c188852.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c188852.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c188852.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c188852.damcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (Duel.GetTurnPlayer()==tp and ph==PHASE_MAIN1 or ph==PHASE_MAIN2) or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function c188852.thfilter(c)
	return c:IsSetCard(0x16) and c:IsLevelAbove(5) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToHand()
end
function c188852.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c188852.thfilter,tp,LOCATION_DECK,0,1,nil) end
	local c=e:GetHandler()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c188852.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Damage(p,d,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c188852.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g2>0 then
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
		end
	end
end
