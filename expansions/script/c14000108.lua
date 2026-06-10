--死境突入
local m=14000108
local cm=_G["c"..m]
function cm.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SUMMON+CATEGORY_POSITION+CATEGORY_MSET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(cm.actcon)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.thcon)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
end
function cm.BRAVE(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_brave
end
function cm.setfilter(c,e,tp)
	return c:IsFaceup() and c:GetSequence()<5
end
function cm.actcon(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_SZONE,0,1,nil)
end
function cm.filter(c,e,tp)
	return c:IsFaceup() and c:IsCanTurnSet() and c:GetSummonPlayer()==1-tp and (not e or c:IsRelateToEffect(e))
end
function cm.sumfilter(c,tp)
	if c:IsLevelBelow(4) or not cm.BRAVE(c) then return false end
	if c:IsLocation(LOCATION_SZONE) then
		local min,max=c:GetTributeRequirement()
		local ct=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
		local ct1=Duel.GetReleaseGroupCount(tp)
		ct=ct+ct1
		if ct<1 or ct<min then return false end
	end
	return c:IsSummonable(true,nil,1)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,e:GetHandler(),1-tp)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,2,nil)
	if #g>0 then
		if Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)~=0 and Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,1,nil,tp)
			local tc=g:GetFirst()
			if tc then
				if tc:IsFacedown() and tc:IsOnField() then Duel.ConfirmCards(1-tp,tc) end
				Duel.Summon(tp,tc,true,nil,1)
			end
		end
	end
end
function cm.thcon(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_SZONE,0,1,nil)
end
function cm.thfilter(c)
	return c:IsCode(14000107) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end