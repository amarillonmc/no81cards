function c118426889.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_FAIRY),2,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,118426889)
	e1:SetCondition(c118426889.condition2)
	e1:SetCost(c118426889.cost2)
	e1:SetTarget(c118426889.target2)
	e1:SetOperation(c118426889.operation2)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(118426889,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x97))
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetCondition(c118426889.effcon)
	e2:SetLabel(2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(118426889,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c118426889.srtg)
	e4:SetOperation(c118426889.srop)
	e4:SetCondition(c118426889.effcon)
	e4:SetLabel(5)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(118426889,2))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c118426889.spcost)
	e5:SetOperation(c118426889.spop)
	e5:SetCondition(c118426889.effcon)
	e5:SetLabel(9)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(118426889,3))
	e6:SetCategory(CATEGORY_DECKDES)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c118426889.skcon)
	e6:SetTarget(c118426889.sktg)
	e6:SetOperation(c118426889.skop)
	c:RegisterEffect(e6)
end
function c118426889.condition2(e,tp,eg,ep,ev,re,r,rp,chk)
	return re:GetHandler():IsSetCard(0x97)
end
function c118426889.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ConfirmCards(1-tp,e:GetHandler())
end
function c118426889.filter2(c,tp,sc)
	return c:IsSetCard(0x97) and (c:IsControler(tp) or c:IsFaceup()) and Duel.IsExistingMatchingCard(c118426889.filter4,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp,c,sc)
end
function c118426889.filter4(c,tp,mc,sc)
	return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc),sc)>0
end
function c118426889.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c118426889.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp,c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,true,true,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_EXTRA)
end
function c118426889.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,c118426889.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp,c)
	local tc=tg:GetFirst()
	if tc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		tg:Merge(Duel.SelectMatchingCard(tp,c118426889.filter4,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,tc,tp,tc,c))
		if tg and Duel.SendtoGrave(tg,REASON_EFFECT)==2 then
			Duel.SpecialSummon(c,SUMMON_TYPE_LINK,tp,tp,true,true,POS_FACEUP)
		end
	end
end
function c118426889.efffilter(c)
	return c:IsPosition(POS_FACEUP) and c:IsSetCard(0x97) and c:IsType(TYPE_MONSTER)
end
function c118426889.effcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroup(c118426889.efffilter,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,0,nil):GetCount()>=e:GetLabel()
end
function c118426889.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,0x97) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c118426889.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,0x97)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c118426889.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c118426889.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c118426889.actlimit)
	e1:SetReset(RESET_SELF_TURN+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c118426889.actlimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c118426889.filter3(c)
	return c:IsSetCard(0x97) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c118426889.skcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return tp~=Duel.GetTurnPlayer()
end
function c118426889.sktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(c118426889.filter3,tp,LOCATION_DECK,0,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	end
end
function c118426889.skop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c118426889.filter3,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c118426889.filter3,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			if Duel.SendtoGrave(tc,REASON_EFFECT)<1 then return end
		else
			Duel.ConfirmCards(1-tp,Duel.GetFieldGroup(tp,LOCATION_DECK,0))
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetCode(EFFECT_SKIP_TURN)
		e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
	else
		Duel.ConfirmCards(1-tp,Duel.GetFieldGroup(tp,LOCATION_DECK,0))
	end
end
