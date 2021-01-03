--罗德岛·狙击干员-松果
function c79029364.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c79029364.lcheck)
	c:EnableReviveLimit() 
	--th 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,79029364)
	e1:SetCondition(c79029364.thcon)
	e1:SetTarget(c79029364.thtg)
	e1:SetOperation(c79029364.thop)
	c:RegisterEffect(e1) 
	--place
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1)
	e5:SetTarget(c79029364.target)
	e5:SetOperation(c79029364.operation)
	c:RegisterEffect(e5)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029364,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,09029364)	
	e2:SetCost(c79029364.spcost)
	e2:SetTarget(c79029364.sptg)
	e2:SetOperation(c79029364.spop)
	c:RegisterEffect(e2) 
end 
function c79029364.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xa900)
end
function c79029364.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c79029364.thfilter(c,e,tp)
	return c:IsSetCard(0xa90f) and c:IsAbleToHand()
end
function c79029364.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029364.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Debug.Message("和施工队长差不多意思呗？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029364,0))
end
function c79029364.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c79029364.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
end
function c79029364.xfilter(c)
	return c:IsSetCard(0xa90f) and not c:IsForbidden() and c:IsType(TYPE_EQUIP)
end
function c79029364.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029364.xfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c79029364.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Debug.Message("电量储备还很充足！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029364,1))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c79029364.xfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_CONTINUOUS+TYPE_SPELL)
		tc:RegisterEffect(e1)
	end
end
function c79029364.cofil(c)
	return c:IsSetCard(0xa90f) and c:IsAbleToGraveAsCost()
end
function c79029364.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029364.cofil,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c79029364.cofil,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c79029364.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c79029364.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Debug.Message("那个......目的地在哪儿来着......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029364,2))
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end













