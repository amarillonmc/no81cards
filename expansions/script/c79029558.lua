--真红眼极炎龙皇
function c79029558.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_MONSTER),3,99,c79029558.lcheck)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029558,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c79029558.spcon)
	e1:SetTarget(c79029558.sptg)
	e1:SetOperation(c79029558.spop)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c79029558.atkval)
	c:RegisterEffect(e4)
	--send to grave
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(79029558,0))
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c79029558.stgtarget)
	e5:SetCost(c79029558.stgcost)
	e5:SetOperation(c79029558.stgoperation)
	c:RegisterEffect(e5)
end
function c79029558.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x3b)
end
function c79029558.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c79029558.spfilter(c,e,tp)
	return c:IsSetCard(0x3b) and not c:IsCode(c79029558) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) 
end
function c79029558.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c79029558.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c79029558.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>2 then ft=2 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79029558.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
 end  
function c79029558.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3b)
end
function c79029558.atkval(e,c)
	local g=Duel.GetMatchingGroup(c79029558.atkfilter,0,LOCATION_MZONE,LOCATION_MZONE,c)
	local atk=g:GetSum(Card.GetBaseAttack)
	return atk
end
function c79029558.cfilter(c,tp)
	local atk=c:GetAttack()
	if atk<0 then atk=0 end
	return c:IsSetCard(0x3b) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c79029558.dfilter,tp,0,LOCATION_MZONE,1,nil,atk)
end
function c79029558.dfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()<=atk
end
function c79029558.stgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029558.cfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c79029558.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local atk=g:GetFirst():GetAttack()
	if atk<0 then atk=0 end
	e:SetLabel(atk)
	Duel.SendtoGrave(g,REASON_COST)
end
function c79029558.stgtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c79029558.dfilter,tp,0,LOCATION_MZONE,nil,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c79029558.stgoperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c79029558.dfilter,tp,0,LOCATION_MZONE,nil,e:GetLabel())
	Duel.SendtoGrave(g,REASON_EFFECT)
end
