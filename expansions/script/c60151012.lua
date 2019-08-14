--虚空之夜 晓美焰
function c60151012.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),3,2)
	c:EnableReviveLimit()
	--cannot change position
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c60151012.atktarget2)
	e1:SetValue(0)
	c:RegisterEffect(e1)
	--atk pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60151012,0))
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1,60151012)
	e2:SetCost(c60151012.atkcost)
	e2:SetTarget(c60151012.atktg)
	e2:SetOperation(c60151012.atkop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60151012,1))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCountLimit(1,6011012)
	e3:SetTarget(c60151012.pctg)
	e3:SetOperation(c60151012.pcop)
	c:RegisterEffect(e3)
end
function c60151012.aclimit1(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
function c60151012.atktarget2(e,c)
	return c:IsDefensePos()
end
function c60151012.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60151012.filter3(c)
	return c:IsFaceup() and c:IsSetCard(0x5b23) and c:IsType(TYPE_MONSTER)
end
function c60151012.filter4(c)
	return c:IsFaceup()
end
function c60151012.filter5(c)
	return c:IsPosition(POS_FACEUP_ATTACK)
end
function c60151012.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c60151012.filter3,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingMatchingCard(c60151012.filter4,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c60151012.filter3,tp,LOCATION_MZONE,0,1,1,nil)
end
function c60151012.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetAttack()
	local sg=Duel.GetMatchingGroup(c60151012.filter4,tp,0,LOCATION_MZONE,c)
	local tc2=sg:GetFirst()
	while tc2 and tc2:GetBaseAttack()<atk do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc2:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc2:RegisterEffect(e2)
		Duel.ChangePosition(tc2,POS_FACEUP_ATTACK,0,POS_FACEUP_ATTACK,0)
		tc2=sg:GetNext()
	end
end
function c60151012.pctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c60151012.filter5,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c60151012.filter5,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,sg,sg:GetCount(),0,0)
end
function c60151012.pcop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c60151012.filter5,tp,0,LOCATION_MZONE,nil) local c=e:GetHandler()
	if sg:GetCount()==0 then return end
	Duel.ChangePosition(sg,POS_FACEUP_DEFENSE,0,POS_FACEUP_DEFENSE,0,true)
end