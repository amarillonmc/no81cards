--伪骸龙机 心地心
function c79066301.initial_effect(c)
	--special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79066301,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,79066301)
	e1:SetTarget(c79066301.target)
	e1:SetOperation(c79066301.operation)
	c:RegisterEffect(e1)
	--skip 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79066301,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,19066301+EFFECT_COUNT_CODE_DUEL)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_DRAW_PHASE)
	e2:SetCondition(c79066301.lpcon)
	e2:SetCost(c79066301.lpcost)
	e2:SetTarget(c79066301.lptg)
	e2:SetOperation(c79066301.lpop)
	c:RegisterEffect(e2) 
	--remove overlay replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79066301,2))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_MZONE)
	e2:SetCountLimit(1,29066301)
	e2:SetCondition(c79066301.rcon)
	e2:SetOperation(c79066301.rop)
	c:RegisterEffect(e2)   
end
function c79066301.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c79066301.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c79066301.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c79066301.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c79066301.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c79066301.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) then
	   Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end
	if tc:IsRelateToEffect(e) then 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c79066301.efilter)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetOwnerPlayer(tp)
	tc:RegisterEffect(e1)
	--must attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_MUST_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e4:SetTargetRange(0,LOCATION_MZONE)
	tc:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e5:SetValue(c79066301.atklimit)
	tc:RegisterEffect(e5)
	end
end
function c79066301.atklimit(e,c)
	return c==e:GetHandler()
end
function c79066301.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c79066301.ckfil(c)
	local m=_G["c"..c:GetCode()]
	if not m then return false end
	local no=m.xyz_number
	return no and no==92 and c:IsSetCard(0x48) and c:IsType(TYPE_XYZ)
end
function c79066301.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.IsExistingMatchingCard(c79066301.ckfil,tp,LOCATION_MZONE,0,1,nil)
end
function c79066301.lpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c79066301.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c79066301.lpop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	Duel.SkipPhase(1-tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,2,1)
	Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,2)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function c79066301.rcon(e,tp,eg,ep,ev,re,r,rp) 
	return bit.band(r,REASON_COST)~=0 and re:IsActivated() and re:IsActiveType(TYPE_XYZ)
		and re:GetHandler():GetOverlayCount()>=ev-1 and e:GetHandler():IsAbleToHandAsCost() and ep==e:GetOwnerPlayer() 
		and re:GetHandler():IsSetCard(0x48) and re:GetHandler():IsType(TYPE_XYZ)
end
function c79066301.rop(e,tp,eg,ep,ev,re,r,rp)
	return Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end






