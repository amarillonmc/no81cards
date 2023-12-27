--Kamipro 启示录的救援
function c50213245.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,50213245)
	e1:SetCost(c50213245.cost)
	e1:SetTarget(c50213245.target)
	e1:SetOperation(c50213245.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e11:SetCondition(c50213245.handcon)
	c:RegisterEffect(e11)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,50213245)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c50213245.tgtg)
	e2:SetOperation(c50213245.tgop)
	c:RegisterEffect(e2)
end
function c50213245.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c50213245.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,50213245,0xcbf,TYPES_NORMAL_TRAP_MONSTER,500,2500,4,RACE_CYBERSE,ATTRIBUTE_DARK,POS_FACEUP) end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c50213245.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,50213245,0xcbf,TYPES_NORMAL_TRAP_MONSTER,500,2500,4,RACE_CYBERSE,ATTRIBUTE_DARK,POS_FACEUP) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetValue(1)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c50213245.tgfilter(c)
	return c:IsSetCard(0xcbf) and c:IsAbleToGrave()
end
function c50213245.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50213245.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c50213245.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c50213245.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c50213245.cfilter(c)
	return c:IsSetCard(0xcbf) and c:IsFaceup()
end
function c50213245.handcon(e)
	return Duel.IsExistingMatchingCard(c50213245.cfilter,e:GetOwnerPlayer(),LOCATION_MZONE,0,1,nil)
end