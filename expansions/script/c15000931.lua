local m=15000931
local cm=_G["c"..m]
cm.name="溺亡死蔷薇-荆棘托里亚丹"
function cm.initial_effect(c)
	aux.AddCodeList(c,15000920)
	--Calamity Complainer
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,15000931)
	e1:SetCondition(cm.tkcon)
	e1:SetTarget(cm.tktg)
	e1:SetOperation(cm.tkop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_START)
	e2:SetCondition(cm.tk1con)
	c:RegisterEffect(e2)
	--Deckdes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,15000931)
	e3:SetCondition(cm.tgcon)
	e3:SetTarget(cm.tgtg)
	e3:SetOperation(cm.tgop)
	c:RegisterEffect(e3)
end
function cm.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and not Duel.IsPlayerAffectedByEffect(tp,15000923)
end
function cm.tk1con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.IsPlayerAffectedByEffect(tp,15000923)
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ct>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,15000920,nil,TYPES_TOKEN_MONSTER,0,3000,12,RACE_ZOMBIE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerCanSpecialSummonMonster(tp,15000920,nil,TYPES_TOKEN_MONSTER,0,3000,12,RACE_ZOMBIE,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,15000920)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
			if token:IsType(TYPE_NORMAL) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_REMOVE_TYPE)
				e1:SetValue(TYPE_NORMAL)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				token:RegisterEffect(e1,true)
			end
			if not token:IsType(TYPE_EFFECT) then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_ADD_TYPE)
				e2:SetValue(TYPE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				token:RegisterEffect(e2,true)
			end
			token:SetUniqueOnField(1,0,15000920)
			--atkup
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e3:SetCode(EFFECT_UPDATE_ATTACK)
			e3:SetRange(LOCATION_MZONE)
			e3:SetValue(cm.atkval)
			token:RegisterEffect(e3)
			Duel.SpecialSummonComplete()
		end
	end
end
function cm.atkval(e,c)
	local g=Duel.GetFieldGroup(c:GetControler(),LOCATION_GRAVE,0):Filter(Card.IsSetCard,nil,0x3f3f)
	return g:GetSum(Card.GetBaseAttack)
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND) or e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,Card.IsAbleToDeck,p,LOCATION_HAND,0,1,1,nil)
	if Duel.SendtoDeck(g,nil,1,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.DiscardDeck(p,d,REASON_EFFECT)
	end
end