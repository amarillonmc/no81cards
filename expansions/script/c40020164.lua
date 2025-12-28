--假面骑士 空我/升华泰坦
local s,id=GetID()

s.named_with_Kuuga=1
function s.Kuuga(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Kuuga
end

function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.procon)
	e1:SetTarget(s.protg)
	e1:SetOperation(s.proop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.negcon)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
end

function s.procon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local tp_turn=Duel.GetTurnPlayer()==tp 
	
	local is_my_main = tp_turn and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
	
	local is_battle = (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	
	return is_my_main or is_battle
end

function s.hand_kuuga_filter(c)
	return s.Kuuga(c) and c:IsDiscardable(REASON_EFFECT)
end

function s.field_kuuga_lv5_filter(c,tp)
	return s.Kuuga(c) and c:IsFaceup() and c:IsLevelAbove(5) and c:IsAbleToHand() 
		and Duel.GetMZoneCount(tp,c)>0 
end

function s.protg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	
	local b1=c:IsDiscardable(REASON_EFFECT) 
		and Duel.IsExistingMatchingCard(s.hand_kuuga_filter,tp,LOCATION_HAND,0,1,c)
	local b2=c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.IsExistingMatchingCard(s.field_kuuga_lv5_filter,tp,LOCATION_MZONE,0,1,nil,tp)
		
	if chk==0 then return (b1 or b2) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,2,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)

end

function s.proop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_WARRIOR))
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	Duel.RegisterEffect(e2,tp)

	if not c:IsRelateToEffect(e) or not c:IsLocation(LOCATION_HAND) then return end
	
	local b1=c:IsDiscardable(REASON_EFFECT) 
		and Duel.IsExistingMatchingCard(s.hand_kuuga_filter,tp,LOCATION_HAND,0,1,c)
	local b2=c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.IsExistingMatchingCard(s.field_kuuga_lv5_filter,tp,LOCATION_MZONE,0,1,nil,tp)
		
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	elseif b1 then op=0
	elseif b2 then op=1
	else return end
	
	if op==0 then

		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local dg=Duel.SelectMatchingCard(tp,s.hand_kuuga_filter,tp,LOCATION_HAND,0,1,1,c)
		if #dg>0 then
			dg:AddCard(c)
			Duel.BreakEffect()
			Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local bg=Duel.SelectMatchingCard(tp,s.field_kuuga_lv5_filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
		if #bg>0 then
			Duel.BreakEffect()
			if Duel.SendtoHand(bg,nil,REASON_EFFECT)>0 then
				Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end

function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local re_summon=c:GetReasonEffect()
	local is_kuuga=re_summon and s.Kuuga(re_summon:GetHandler())
	
	return is_kuuga 
		and re:IsActiveType(TYPE_MONSTER) 
		and re:GetHandler()~=c
		and Duel.IsChainNegatable(ev) 
		and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end

function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end