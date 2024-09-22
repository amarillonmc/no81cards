--植物娘·胆小菇
function c65830030.initial_effect(c)
	--自己特招
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65830030+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65830030.spcon)
	c:RegisterEffect(e1)
	--手卡特招
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,65830031)
	e3:SetCost(c65830030.cost3)
	e3:SetTarget(c65830030.target3)
	e3:SetOperation(c65830030.activate3)
	c:RegisterEffect(e3)
end



function c65830030.filter(c)
	return c:IsSetCard(0xa33) and c:IsFaceup()
end
function c65830030.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and (Duel.IsExistingMatchingCard(c65830030.filter,c:GetControler(),LOCATION_MZONE,0,1,nil) or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0)
end


function c65830030.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() 
	end
	Duel.SendtoHand(e:GetHandler(),tp,REASON_COST)
end
function c65830030.spfilter(c,e,tp)
	return c:IsSetCard(0xa33) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65830030.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c65830030.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c65830030.activate3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65830030.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end