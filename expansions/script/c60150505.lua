--幻想曲 风与血的追逐
function c60150505.initial_effect(c)
	--summon with no tribute
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(60150505,0))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetCondition(c60150505.ntcon)
	c:RegisterEffect(e0)
	--检索
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60150505,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,60150505)
	e1:SetTarget(c60150505.thtg)
	e1:SetOperation(c60150505.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60150505,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,6010505)
	e3:SetCost(c60150505.e3cost)
	e3:SetTarget(c60150505.e3tg)
	e3:SetOperation(c60150505.e3op)
	c:RegisterEffect(e3)
	--[[
	lvchange
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3606728,0))
	e2:SetCategory(CATEGORY_LVCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c60150505.lvtg)
	e2:SetOperation(c60150505.lvop)
	c:RegisterEffect(e2)
	]]
end
function c60150505.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c60150505.thfilter(c)
	return c:IsSetCard(0xab20) and not c:IsCode(60150505) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c60150505.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150505.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c60150505.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
	local g0=Duel.GetOperatedGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60150505.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	if g0:IsExists(Card.IsSetCard,1,nil,0xab20) then Duel.Draw(tp,1,REASON_EFFECT) end
end
function c60150505.lvfilter(c,lv)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FIEND) and not c:IsCode(60150505) and not c:IsType(TYPE_XYZ) 
	and not c:IsType(TYPE_LINK) and c:GetLevel()~=lv
end
function c60150505.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c60150505.lvfilter(chkc,e:GetHandler():GetLevel()) end
	if chk==0 then return Duel.IsExistingTarget(c60150505.lvfilter,tp,LOCATION_MZONE,0,1,nil,e:GetHandler():GetLevel()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c60150505.lvfilter,tp,LOCATION_MZONE,0,1,1,nil,e:GetHandler():GetLevel())
end
function c60150505.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(tc:GetLevel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end


function c60150505.e3cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c60150505.e3tgf(c,e,tp)
	return c:IsSetCard(0xab20) and not c:IsCode(60150505) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60150505.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c60150505.e3tgf,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60150505.e3op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c60150505.spfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end