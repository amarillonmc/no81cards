--临魔蝶彩
function c33310155.initial_effect(c)
	c:SetSPSummonOnce(33310155)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c33310155.spcon)
	e1:SetOperation(c33310155.spop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--linmo
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c33310155.cost)
	e2:SetTarget(c33310155.tg)
	e2:SetOperation(c33310155.op)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetOperation(c33310155.flagop)
	c:RegisterEffect(e5)
	local e4=e5:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	c33310155[c]=e2
end
function c33310155.flagop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(33310155,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
end
function c33310155.costfil(c)
	return c:IsSetCard(0x55b) and c:IsAbleToHandAsCost() and c:IsFaceup()
end
function c33310155.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33310155.costfil,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():GetFlagEffect(33310155)>0 end
	local g=Duel.SelectMatchingCard(tp,c33310155.costfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c33310155.tgfil(c,e,tp)
	return c:IsSetCard(0x55b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33310155.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33310155.tgfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c33310155.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c33310155.tgfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c33310155.filter(c)
	return c:IsSetCard(0x55b) and c:IsSummonable(true,nil)
end
function c33310155.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33310155.filter,tp,LOCATION_HAND,0,1,nil) and Duel.GetFlagEffect(tp,33310155)==0
end
function c33310155.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(33310155,0)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33310155.filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Summon(tp,g:GetFirst(),true,nil)
	Duel.RegisterFlagEffect(tp,33310155,RESET_PHASE+PHASE_END,0,1)
end
