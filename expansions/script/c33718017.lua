--水再演
function c33718017.initial_effect(c)
	
--让自己场上的1只「水伶女/アクアアクトレス」怪兽回到手卡才能发动。
--从自己的墓地把1只原本卡名包含「水伶女/アクアアクトレス」的怪兽特殊召唤。
--这个效果特殊召唤的怪兽的效果变成在对方回合也能发动的效果。
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c33718017.cost)
	e1:SetTarget(c33718017.target)
	e1:SetOperation(c33718017.operation)
	c:RegisterEffect(e1)
end
function c33718017.filter(c)
	return c:IsSetCard(0xcd) and c:IsAbleToHandAsCost() and c:IsControler(tp)
end
function c33718017.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local sp=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return sp>-1 and Duel.IsExistingMatchingCard(c33718017.filter,tp,LOCATION_MZONE,0,1,nil,sp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c33718017.filter,tp,LOCATION_MZONE,0,1,1,nil,sp)
	Duel.SendtoHand(g,nil,REASON_COST)
end

function c33718017.spfilter(c,e,tp)
	return c:IsSetCard(0xcd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33718017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33718017.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
end
function c33718017.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local monster=Duel.SelectMatchingCard(tp,c33718017.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if monster then
		if Duel.SpecialSummon(monster,nil,tp,tp,false,false,POS_FACEUP)==0 then return end
		local e2=Effect.CreateEffect(monster)
		e2:SetDescription(aux.Stringid(337180117,0))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(33718017)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(1,0)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		monster:RegisterEffect()
	end
end