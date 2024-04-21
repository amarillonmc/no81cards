--匿 世 柩 的 观 者
local m=22348381
local cm=_G["c"..m]
function cm.initial_effect(c)
	--adjust
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c22348381.adjustop)
	c:RegisterEffect(e1)
	--spsummon2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e2:SetCountLimit(2,22348381)
	e2:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c22348381.sppcost)
	e2:SetTarget(c22348381.spptg)
	e2:SetOperation(c22348381.sppop)
	c:RegisterEffect(e2)
	if not c22348381.global_check then
		c22348381.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c22348381.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c22348381.sppcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c22348381.spfilter1(c,loc)
	return (c:IsFacedown() or c:IsSetCard(0x370b)) and ((c:IsAbleToHand() and loc==LOCATION_REMOVED) or (c:IsAbleToRemove() and loc==LOCATION_HAND))
end
function c22348381.spptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local loc=e:GetActivateLocation()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22348381.spfilter1(chkc,loc) end
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingTarget(c22348381.spfilter1,tp,LOCATION_MZONE,0,1,nil,loc) end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c22348381.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,loc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND+LOCATION_REMOVED)
	if loc==LOCATION_REMOVED then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_MZONE)
	elseif loc==LOCATION_HAND then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,LOCATION_MZONE)
	end
end
function c22348381.sppop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and tc:IsRelateToEffect(e) then
			Duel.BreakEffect()
		if e:GetActivateLocation()==LOCATION_HAND then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		elseif e:GetActivateLocation()==LOCATION_REMOVED then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
function c22348381.filter1(c)
	return c:IsOriginalCodeRule(22348381) and c:IsFacedown() and c:GetColumnGroup():IsExists(Card.IsControler,1,nil,1-c:GetControler())
end
function c22348381.checkop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local g1=Duel.GetMatchingGroup(c22348381.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.ChangePosition(g1,POS_FACEUP_ATTACK)
end
function c22348381.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local c=e:GetHandler()
	if not c:GetColumnGroup():IsExists(Card.IsControler,1,nil,1-tp) and c:IsFaceup() then Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end
end


