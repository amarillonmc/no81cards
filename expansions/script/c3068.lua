--祭礼魔械 艾露·夜枭
function c3068.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1012),6,2)
	c:EnableReviveLimit()
	--to hand and damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3068,0))
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c3068.thtg)
	e1:SetCondition(c3068.thcon)
	e1:SetOperation(c3068.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3068,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c3068.spcost)
	e1:SetTarget(c3068.sptg)
	e1:SetOperation(c3068.spop)
	c:RegisterEffect(e1)
end	
function c3068.cfilter(c)
	return c:IsSetCard(0x1012) and c:IsType(TYPE_MONSTER)
end
function c3068.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c3068.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3068.cfilter,tp,LOCATION_REMOVED,0,1,nil) end
end
function c3068.thop(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroupCount(c3068.cfilter,tp,LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,sg,nil)
	if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
	end	
	Duel.BreakEffect()
	local g1=Duel.GetOperatedGroup()
    Duel.Damage(1-tp,g1:GetCount()*600,REASON_EFFECT)
end
function c3068.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c3068.spfilter(c,e,tp)
	return c:IsSetCard(0x1012) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c3068.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c3068.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c3068.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c3068.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
	    Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
	    local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
	    e2:SetType(EFFECT_TYPE_SINGLE)
	    e2:SetCode(EFFECT_DISABLE)
	    e2:SetReset(RESET_EVENT+0xfe0000)
	    tc:RegisterEffect(e2,true)
	    local e3=Effect.CreateEffect(e:GetHandler())
	    e3:SetType(EFFECT_TYPE_SINGLE)
	    e3:SetCode(EFFECT_DISABLE_EFFECT)
	    e3:SetReset(RESET_EVENT+0xfe0000)
	    tc:RegisterEffect(e3,true)
		Duel.SpecialSummonComplete()
	end
end