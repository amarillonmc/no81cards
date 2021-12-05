local m=15000933
local cm=_G["c"..m]
cm.name="饥亡死蔷薇-迷光希露菲德"
function cm.initial_effect(c)
	aux.AddCodeList(c,15000920)
	--Calamity Complainer
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,15000933)
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
	--SearchCard
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,15000933)
	e3:SetCost(cm.tgcost)
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
function cm.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.filter(c)
	return c:IsSetCard(0x3f3f) and c:IsType(TYPE_MONSTER) and not c:IsCode(15000933) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end