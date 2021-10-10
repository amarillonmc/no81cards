--米诺斯·近卫干员-帕拉斯
function c79029907.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029907,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,79029907)
	e1:SetCondition(c79029907.spcon)
	e1:SetTarget(c79029907.sptg)
	e1:SetOperation(c79029907.spop)
	c:RegisterEffect(e1)   
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,09029907)
	e2:SetCost(c79029907.apcost)
	e2:SetTarget(c79029907.aptg)
	e2:SetOperation(c79029907.apop)
	c:RegisterEffect(e2) 
end
function c79029907.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa900) and c:IsType(TYPE_MONSTER)
end
function c79029907.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c79029907.cfilter,tp,LOCATION_ONFIELD,0,2,nil)
end
function c79029907.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c79029907.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	Duel.BreakEffect()
	local x=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0xa900)
	Duel.Recover(tp,x*1000,REASON_EFFECT)
	end
	Debug.Message("不需畏惧，我们会战胜那些鲁莽的家伙！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029907,0))
end
function c79029907.ctfil(c)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0xb90d,0xc90e)
end
function c79029907.apcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029907.ctfil,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c79029907.ctfil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c79029907.aptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0xa900) and e:GetHandler():GetAttack()>0 end
end
function c79029907.apop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0xa900)
	Debug.Message("英雄们啊，为这最强大的信念，请站在我们这边。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029907,1))
	if g:GetCount()>0 and c:GetAttack()>0 then 
	local tc=g:GetFirst()
	while tc do
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)  
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(c:GetAttack())
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	tc=g:GetNext()
	end
	end
end




