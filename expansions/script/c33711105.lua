--动物朋友 玄武 ～震撼的地落～
function c33711105.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c33711105.matfilter,2)  
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33711105,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33711105)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c33711105.sptg)
	e1:SetOperation(c33711105.spop)
	c:RegisterEffect(e1) 
	--Cannot be Break
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33711105,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,33711106)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c33711105.cost)
	e2:SetOperation(c33711105.operation)
	c:RegisterEffect(e2)
	--cannot be target/indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c33711105.indcon)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	c:RegisterEffect(e4)
end
function c33711105.matfilter(c)
	return c:IsSetCard(0x442)
end
function c33711105.spfilter(c,e,tp,zone)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) and c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER)
end
function c33711105.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if chk==0 then return Duel.IsExistingMatchingCard(c33711105.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c33711105.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c33711105.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,zone)
	if zone~=0 and sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c33711105.tdfilter(c)
	return c:IsSetCard(0x442) and c:IsAbleToDeckAsCost()
end
function c33711105.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33711105.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c33711105.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c33711105.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c33711105.cndestg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(aux.indoval)
	Duel.RegisterEffect(e2,tp)
end
function c33711105.cndestg(e,c)
	return c:IsSetCard(0x442) and c:IsFaceup()
end
function c33711105.cntgfilter(c)
	return c:IsSetCard(0x442) and c:IsFaceup()
end
function c33711105.indcon(e)
	return e:GetHandler():GetLinkedGroupCount()>0 and e:GetHandler():GetLinkedGroup():IsExists(c33711105.cntgfilter,1,nil)
end