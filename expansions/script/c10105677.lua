function c10105677.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1084),4,2)
	c:EnableReviveLimit()
    	 --伤害计算
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_END_PHASE)
   	e1:SetCountLimit(1,10105677)
	e1:SetCost(c10105677.cost)
	e1:SetTarget(c10105677.batg)
	e1:SetOperation(c10105677.baop)
	c:RegisterEffect(e1)
    	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10105677,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c10105677.spcon)
	e2:SetTarget(c10105677.sptg)
	e2:SetOperation(c10105677.spop)
	c:RegisterEffect(e2)
    end
function c10105677.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10105677.batg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return c:IsAttackable()
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
end
function c10105677.baop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackable() and c:IsControler(tp) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local tc=g:GetFirst()
		if tc:IsControler(1-tp) and tc:IsRelateToEffect(e) then
			Duel.CalculateDamage(c,tc)
		end
	end
end
function c10105677.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():GetOverlayCount()>0
end
function c10105677.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10105677.mfilter(c)
	return c:IsSetCard(0x1084) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function c10105677.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10105677.mfilter),tp,LOCATION_GRAVE,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10105677,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local mg=g:Select(tp,1,1,nil)
			Duel.Overlay(c,mg)
        local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_SET_ATTACK_FINAL) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(c:GetBaseAttack()*2)		
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1)   
		end
	end
end