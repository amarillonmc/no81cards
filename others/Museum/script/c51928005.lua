--狂风精灵 烈风
function c51928005.initial_effect(c)
	 --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,51928005+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c51928005.spcon)
	e1:SetOperation(c51928005.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,51928005)
	e2:SetTarget(c51928005.thtg)
	e2:SetOperation(c51928005.thop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(51928005,ACTIVITY_SPSUMMON,c51928005.counterfilter)
end
function c51928005.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or (c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_THUNDER))
end
--------------------------------
function c51928005.filter(c)
	return c:IsType(TYPE_TUNER) and c:IsFaceup()
end
function c51928005.spcon(e,c)
	if c==nil then return true end
	return Duel.GetCustomActivityCount(51928005,tp,ACTIVITY_SPSUMMON)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c51928005.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c51928005.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c51928005.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c51928005.splimit(e,c)
	return not (c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_THUNDER)) and c:IsLocation(LOCATION_EXTRA)
end
-------------------------------------

function c51928005.thfilter(c)
	return c:IsSetCard(0x9256) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c51928005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51928005.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c51928005.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c51928005.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end