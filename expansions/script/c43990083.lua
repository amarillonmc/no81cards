--血棉花
local m=43990083
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,c43990083.ffilter,2,99,true)
	--handes
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,43990083)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c43990083.tgcon)
	e1:SetTarget(c43990083.tgtg)
	e1:SetOperation(c43990083.tgop)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCondition(aux.dsercon)
	e2:SetTarget(c43990083.contg)
	e2:SetOperation(c43990083.conop)
	c:RegisterEffect(e2)
	
end
function c43990083.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(5)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,5)
end
function c43990083.tgop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,d,REASON_EFFECT)
	local tg=Duel.GetOperatedGroup()
	if not tg:IsExists(Card.IsRace,1,nil,RACE_ILLUSION) then
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end
function c43990083.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c43990083.ffilter(c,fc)
	return c:IsRace(RACE_ILLUSION)
end
function c43990083.contg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return bc and bc:IsRelateToBattle() and e:GetHandler():GetAttack()>0 and bc:GetAttack()>0 end
	local atk=bc:GetAttack()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c43990083.conop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsAttack(0) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(0)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	if bc:IsRelateToBattle() and bc:IsFaceup() and not bc:IsAttack(0) then
		local atk=bc:GetAttack()
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end
