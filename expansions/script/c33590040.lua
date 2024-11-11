local m=33590040
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP,EVENT_SPSUMMON_SUCCESS)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetRange(LOCATION_DECK)
	e0:SetCountLimit(1,m)
	e0:SetCode(EVENT_BATTLE_CONFIRM)
	e0:SetCondition(cm.spcon)
	e0:SetTarget(cm.sptg)
	e0:SetOperation(cm.spop)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m+1)
	e1:SetCost(cm.secost)
	e1:SetTarget(cm.setg)
	e1:SetOperation(cm.seop)
	--c:RegisterEffect(e1)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return false end
	local tg=g:GetMaxGroup(Card.GetAttack)
	local ac=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	e:SetLabelObject(bc)
	return bc and bc:IsControler(1-tp) and ac:IsControler(tp) and bc:GetAttack()>ac:GetAttack() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tg:IsExists(Card.IsControler,1,nil,1-tp)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=e:GetLabelObject()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 and bc then
	    Duel.BreakEffect()
		Duel.CalculateDamage(c,bc)
	end
end
function cm.secost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.thfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToHand() and c:IsLevelAbove(7)
end
function cm.setg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.seop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(cm.sumlimit)
		e1:SetLabel(tc:GetCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_MSET)
		Duel.RegisterEffect(e3,tp)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_ACTIVATE)
		e4:SetValue(cm.aclimit)
		Duel.RegisterEffect(e4,tp)
	end
end
function cm.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER)
end