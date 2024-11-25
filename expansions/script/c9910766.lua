--虹彩偶像舞台 闪耀触摸
function c9910766.initial_effect(c)
	aux.AddCodeList(c,9910764)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c9910766.activate)
	c:RegisterEffect(e1)
	--spsummon limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c9910766.sumlimit)
	c:RegisterEffect(e2)
	--pzone set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c9910766.pscost)
	e3:SetTarget(c9910766.pstg)
	e3:SetOperation(c9910766.psop)
	c:RegisterEffect(e3)
end
function c9910766.thfilter(c)
	return c:IsCode(9910764) and c:IsAbleToHand()
end
function c9910766.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c9910766.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910766,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c9910766.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA)
end
function c9910766.pscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,600) end
	Duel.PayLPCost(tp,600)
end
function c9910766.cfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsSummonLocation(LOCATION_HAND)
end
function c9910766.psfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x5951) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c9910766.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=0
	if Duel.IsExistingMatchingCard(c9910766.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then loc=LOCATION_DECK end
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c9910766.psfilter,tp,LOCATION_EXTRA+LOCATION_REMOVED+loc,0,1,nil) end
end
function c9910766.psop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local loc=0
	if Duel.IsExistingMatchingCard(c9910766.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then loc=LOCATION_DECK end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c9910766.psfilter,tp,LOCATION_EXTRA+LOCATION_REMOVED+loc,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
