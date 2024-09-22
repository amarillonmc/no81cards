--植物娘·睡莲
function c65830005.initial_effect(c)
	--墓地跳
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65830005,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,65830005)
	e1:SetLabelObject(e0)
	e1:SetCondition(c65830005.spcon)
	e1:SetTarget(c65830005.sptg)
	e1:SetOperation(c65830005.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--特招
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,65830006)
	e3:SetTarget(c65830005.target)
	e3:SetOperation(c65830005.operation)
	c:RegisterEffect(e3)
end


function c65830005.cfilter(c,tp,se)
	return c:IsFaceup() and c:IsSummonPlayer(tp) and c:IsFaceup()
end
function c65830005.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65830005.cfilter,1,nil,tp)
end
function c65830005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65830005.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end


function c65830005.filter(c,e,tp)
	return c:IsSetCard(0xa33) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65830005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c65830005.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c65830005.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp,c65830005.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) and c:IsRelateToEffect(e) then 
	local tc=g:GetFirst()
	Duel.BreakEffect()
	Duel.Equip(tp,c,tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetLabelObject(tc)
	e1:SetValue(c65830005.eqlimit)
	c:RegisterEffect(e1)
	end
end
function c65830005.eqlimit(e,c)
	return c==e:GetLabelObject()
end

