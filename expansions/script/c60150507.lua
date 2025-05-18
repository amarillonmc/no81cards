--幻想曲 纯白的女骑士
function c60150507.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60150507,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,60150507)
	e1:SetCost(c60150507.cost)
	e1:SetTarget(c60150507.thtg)
	e1:SetOperation(c60150507.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60150507,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,6010507)
	e2:SetCost(c60150507.cost)
	e2:SetTarget(c60150507.thtg2)
	e2:SetOperation(c60150507.thop2)
	c:RegisterEffect(e2)
	--[[lvchange
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(3606728,0))
	e3:SetCategory(CATEGORY_LVCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(c60150507.cost)
	e3:SetTarget(c60150507.lvtg)
	e3:SetOperation(c60150507.lvop)
	c:RegisterEffect(e3)]]
	Duel.AddCustomActivityCounter(60150507,ACTIVITY_SPSUMMON,c60150507.counterfilter)
end
function c60150507.counterfilter(c)
	return (c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FIEND))
end
function c60150507.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(60150507,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c60150507.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c60150507.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FIEND))
end
function c60150507.thfilter(c,e,tp)
	return c:IsSetCard(0xab20) and not c:IsCode(60150507) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60150507.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c60150507.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60150507.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
	local g0=Duel.GetOperatedGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c60150507.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	if g0:IsExists(Card.IsSetCard,1,nil,0xab20) then 
		Duel.Draw(tp,1,REASON_EFFECT) 
	end
end
function c60150507.thfilter2(c,e,tp)
	return c:IsSetCard(0xab20) and not c:IsCode(60150507) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60150507.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c60150507.thfilter2,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60150507.thop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c60150507.thfilter2),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c60150507.lvfilter(c,lv)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FIEND) and not c:IsType(TYPE_XYZ) and not c:IsType(TYPE_LINK) and c:GetLevel()~=lv
end
function c60150507.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c60150507.lvfilter,tp,LOCATION_GRAVE,0,1,nil,e:GetHandler():GetLevel()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c60150507.lvfilter,tp,LOCATION_GRAVE,0,1,1,nil,e:GetHandler():GetLevel())
end
function c60150507.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(tc:GetLevel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end