--阿戈尔·术士干员-深靛
function c79029476.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xa900),aux.NonTuner(nil),1)
	c:EnableReviveLimit()   
	--th
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,79029476)
	e1:SetTarget(c79029476.thtg)
	e1:SetOperation(c79029476.thop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1,19029476)
	e2:SetCondition(c79029476.spcon)
	e2:SetTarget(c79029476.sptg)
	e2:SetOperation(c79029476.spop)
	c:RegisterEffect(e2)	
end
function c79029476.thfil(c) 
	return c:IsAbleToHand() and c:IsRace(RACE_CYBERSE) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c79029476.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029476.thfil,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_DECK)
end
function c79029476.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c79029476.thfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end
	Debug.Message("跟着光走。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029476,3))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,1,nil)
	if Duel.SendtoHand(sg,tp,REASON_EFFECT) then
	Duel.ConfirmCards(1-tp,sg)
	if Duel.CheckLPCost(tp,2000) and Duel.SelectYesNo(tp,aux.Stringid(79029476,0)) then
	Duel.BreakEffect()
	Debug.Message("好的......我会维持这光亮，大家不要走散。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029476,4))
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029476,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTarget(c79029476.exstg)
	Duel.RegisterEffect(e2,tp)  
	end
	end
end
function c79029476.exstg(e,c)
	return c:IsSetCard(0xa900)
end
function c79029476.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_SUMMON)
end
function c79029476.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79029476.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE) then
	Debug.Message("我准备好了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029476,5))
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	if c:GetReasonCard():IsSetCard(0xa900) and c:GetReasonCard():IsAttribute(ATTRIBUTE_WATER) and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(79029476,2)) then 
	Debug.Message("海面不太平静。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029476,6))
	Duel.Draw(tp,1,REASON_EFFECT)
	end
	end
end









