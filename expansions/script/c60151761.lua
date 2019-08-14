--符文仙境
function c60151761.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	--destroy
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60151761,0))
    e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCountLimit(1,60151761)
    e2:SetTarget(c60151761.target)
    e2:SetOperation(c60151761.operation)
    c:RegisterEffect(e2)
	--
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60151761,1))
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetCountLimit(1,60151761)
    e3:SetCondition(c60151761.drcon)
    e3:SetTarget(c60151761.drtg)
    e3:SetOperation(c60151761.drop)
    c:RegisterEffect(e3)
end
function c60151761.filter1(c,ft)
	if ft==0 then
		return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
	else
		return c:IsType(TYPE_MONSTER) and ((c:IsLocation(LOCATION_MZONE) and c:IsFaceup()) or c:IsLocation(LOCATION_HAND))
	end
end
function c60151761.filter2(c,e,tp)
    return c:IsSetCard(0x3b26) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60151761.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151761.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,ft)
        and Duel.IsExistingMatchingCard(c60151761.filter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c60151761.operation(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c60151761.filter1,tp,LOCATION_MZONE,0,1,1,nil,ft)
		if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c60151761.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c60151761.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,ft)
		if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c60151761.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c60151761.cfilter(c,tp)
    return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp 
		and c:GetSummonLocation()==LOCATION_GRAVE and c:IsSetCard(0x3b26) and c:IsType(TYPE_MONSTER)
end
function c60151761.drcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c60151761.cfilter,1,nil,tp)
end
function c60151761.thfilter(c)
    return c:IsSetCard(0x3b26) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c60151761.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151761.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c60151761.drop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60151761.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.SendtoHand(g,nil,REASON_EFFECT)
    end
end
