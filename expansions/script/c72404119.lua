--大庭院的辉明 格莉泽尔
function c72404119.initial_effect(c)
	--spsummon itself
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72404119,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,72404119)
	e1:SetCost(c72404119.cost1)
	e1:SetTarget(c72404119.target1)
	e1:SetOperation(c72404119.operation1)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72404119,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,72404120)
	e2:SetTarget(c72404119.target2)
	e2:SetOperation(c72404119.operation2)
	c:RegisterEffect(e2)
end

--e1
function c72404119.costfilter(c)
	return  c:IsRace(RACE_PLANT) 
end
function c72404119.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c72404119.costfilter,1,e:GetHandler(),e,tp) end
	local g=Duel.SelectReleaseGroupEx(tp,c72404119.costfilter,1,1,e:GetHandler(),e,tp)
	Duel.Release(g,REASON_COST)
end
function c72404119.filter1(c)
	return c:IsSetCard(0x720) and c:IsFaceup()
end
function c72404119.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72404119.filter1,tp,LOCATION_MZONE,0,1,nil) end
end
function c72404119.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
	local g=Duel.SelectMatchingCard(tp,c72404119.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	local gx=Group.GetFirst(g)
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)
	local lv=Duel.AnnounceLevel(tp,1,10)
	if gx:IsFaceup() then
	local e1=Effect.CreateEffect(e:GetOwner())
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_CHANGE_LEVEL)
		  e1:SetValue(lv)
		  e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		  gx:RegisterEffect(e1)
	end
end

--e2
function c72404119.filter2(c,e,tp)
	return c:IsSetCard(0x720) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c72404119.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72404119.filter2,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c72404119.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c72404119.filter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end