--Lazer·机车玩家Lv.1
function c9980980.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,c9980980.mfilter,1,1)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980980,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9980980)
	e1:SetCondition(c9980980.thcon)
	e1:SetTarget(c9980980.thtg)
	e1:SetOperation(c9980980.thop)
	c:RegisterEffect(e1)
	--change level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,99809800)
	e2:SetCost(c9980980.lvcost)
	e2:SetOperation(c9980980.lvop)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980980.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9980980.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980980,0))
end
function c9980980.mfilter(c)
	return c:IsLevelBelow(4) and c:IsLinkRace(RACE_CYBERSE)
end
function c9980980.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9980980.thfilter(c)
	return c:IsCode(9980976) and c:IsAbleToHand()
end
function c9980980.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980980.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9980980.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9980980.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9980980.cfilter(c,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsSetCard(0x3bc3) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c9980980.lvfilter,tp,LOCATION_MZONE,0,1,nil,lv)
end
function c9980980.lvfilter(c,lv)
	return c:IsFaceup() and c:IsLevelAbove(0) and not c:IsLevel(lv)
end
function c9980980.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980980.cfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9980980.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetFirst():GetLevel())
end
function c9980980.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=e:GetLabel()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c9980980.lvfilter,tp,LOCATION_MZONE,0,nil,0)
	local lc=g:GetFirst()
	while lc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		lc:RegisterEffect(e1)
		lc=g:GetNext()
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980980,1))
end