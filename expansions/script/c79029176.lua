--深海猎人·近卫干员-幽灵鲨·肉斩骨断
function c79029176.initial_effect(c)
	--Cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4779091,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c79029176.spcon)
	e2:SetTarget(c79029176.sptg)
	e2:SetOperation(c79029176.spop)
	c:RegisterEffect(e2) 
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--damage val
	local e7=e5:Clone()
	e7:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e7)  
	--half
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e8:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetOperation(c79029176.lpop)
	c:RegisterEffect(e8) 
	--to 100
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c79029176.con)
	e1:SetOperation(c79029176.op)
	c:RegisterEffect(e1)	
end
c79029176.card_code_list={79029137}
c79029176.assault_name=79029085
function c79029176.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end
function c79029176.filter(c,e,tp)
	return c:IsCode(79029085) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c79029176.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c79029176.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c79029176.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79029176.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c79029176.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
end
function c79029176.con(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedGroup()
	return Duel.IsExistingMatchingCard(c79029176.fil,tp,LOCATION_MZONE,0,2,nil,zone)
end
function c79029176.fil(c,g)
	return c:IsAbleToGrave() and g:IsContains(c)
end
function c79029176.op(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedGroup()
	if not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,2,nil,zone) then return end
	local g=Duel.SelectMatchingCard(tp,c79029176.fil,tp,LOCATION_MZONE,0,2,2,nil,zone)
	if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
	Duel.SetLP(1-tp,100)
end
end





