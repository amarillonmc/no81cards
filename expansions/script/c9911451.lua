--闪蝶幻乐主唱 幻想家
function c9911451.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),aux.NonTuner(Card.IsAttribute,ATTRIBUTE_LIGHT+ATTRIBUTE_DARK),1)
	--reverse deck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REVERSE_DECK)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	c:RegisterEffect(e1)
	--change effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c9911451.chcon)
	e2:SetCost(c9911451.chcost)
	e2:SetTarget(c9911451.chtg)
	e2:SetOperation(c9911451.chop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c9911451.thcon)
	e3:SetTarget(c9911451.thtg)
	e3:SetOperation(c9911451.thop)
	c:RegisterEffect(e3)
end
function c9911451.chcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsDisabled()
end
function c9911451.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,rp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,rp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9911451.setfilter(c,e,tp)
	if c:IsType(TYPE_MONSTER) then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	else
		return (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and Duel.IsPlayerCanSSet(tp,c)
	end
end
function c9911451.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc1=Duel.GetDecktopGroup(1-rp,1):GetFirst()
	local tc2=Duel.GetFieldCard(1-rp,LOCATION_GRAVE,Duel.GetFieldGroupCount(1-rp,LOCATION_GRAVE,0)-1)
	if chk==0 then return (tc1 and c9911451.setfilter(tc1,re,rp)) or (tc2 and c9911451.setfilter(tc2,re,rp)) end
end
function c9911451.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c9911451.repop)
end
function c9911451.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local tc1=Duel.GetDecktopGroup(1-tp,1):GetFirst()
	local tc2=Duel.GetFieldCard(1-tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(1-tp,LOCATION_GRAVE,0)-1)
	if tc1 then
		Duel.ConfirmCards(tp,tc1)
		if c9911451.setfilter(tc1,e,tp) then g:AddCard(tc1) end
	end
	if tc2 and c9911451.setfilter(tc2,e,tp) and aux.NecroValleyFilter()(tc2) then g:AddCard(tc2) end
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sc=g:Select(tp,1,1,nil):GetFirst()
	if not sc then return end
	if sc:IsType(TYPE_MONSTER) then
		Duel.DisableShuffleCheck()
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,sc)
	else
		Duel.DisableShuffleCheck()
		Duel.SSet(tp,sc)
	end
end
function c9911451.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function c9911451.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFieldCard(tp,LOCATION_GRAVE,0)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil)
		and tc and tc:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9911451.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if #g==0 then return end
	local tc1=g:GetMinGroup(Card.GetSequence):GetFirst()
	local tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,0)
	if tc1 and tc2 and aux.NecroValleyFilter()(tc2) then
		local sg=Group.FromCards(tc1,tc2)
		Duel.DisableShuffleCheck()
		if Duel.SendtoHand(sg,tp,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
		end
	end
end
