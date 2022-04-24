--战源的龙型杀手
function c12057830.initial_effect(c)
	--nontuner
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(0xff)
	e0:SetCode(EFFECT_NONTUNER)
	e0:SetValue(c12057830.tnval)
	c:RegisterEffect(e0)	  
	--pos 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_GRAVE+LOCATION_REMOVED) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,12057830) 
	e1:SetTarget(c12057830.pstg)  
	e1:SetOperation(c12057830.psop) 
	c:RegisterEffect(e1) 
	--SpecialSummon 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12057829,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,22057829) 
	e2:SetTarget(c12057830.sptg)
	e2:SetOperation(c12057830.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c12057830.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler())
end
function c12057830.pstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsExistingTarget(Card.IsCanChangePosition,tp,0,LOCATION_MZONE,1,nil) end  
	local g=Duel.SelectTarget(tp,Card.IsCanChangePosition,tp,0,LOCATION_MZONE,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end 
function c12057830.psop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then  
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK) 
	end 
end 
function c12057830.spfilter(c,e,tp)
	return c:IsSetCard(0xac2,0x3ac1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and not c:IsCode(12057830)
end 
function c12057830.cpfil(c) 
	return c:IsCanChangePosition() and not c:IsPosition(POS_FACEDOWN_DEFENSE) 
end 
function c12057830.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12057830.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c12057830.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON) 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end 
	local g=Duel.SelectMatchingCard(tp,c12057830.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE) 
	Duel.ConfirmCards(1-tp,g) 
	local g1=Duel.GetMatchingGroup(c12057830.cpfil,tp,LOCATION_MZONE,0,nil) 
	if g1:GetCount()<=0 then return end 
	Duel.BreakEffect() 
	local tc=g1:Select(tp,1,1,nil):GetFirst() 
	Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE) 
	end
end






