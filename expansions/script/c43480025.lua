--被遗忘的研究者 无洺
function c43480025.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,43480025)
	e1:SetCondition(c43480025.spcon) 
	e1:SetCost(c43480025.spcost)
	e1:SetTarget(c43480025.sptg)
	e1:SetOperation(c43480025.spop)
	c:RegisterEffect(e1)
	--SpecialSummon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,43480026)  
	e2:SetTarget(c43480025.psptg)
	e2:SetOperation(c43480025.pspop)
	c:RegisterEffect(e2) 
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(function(e,c) 
	return c==e:GetHandler() or c:IsCode(4348030) end)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c43480025.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x3f13)
end
function c43480025.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c43480025.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c43480025.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c43480025.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c43480025.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c43480025.pspfil(c,e,tp) 
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x3f13) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end 
function c43480025.psptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_PZONE) and c43480025.pspfil(chkc,e,tp) end 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c43480025.pspfil,tp,LOCATION_PZONE,0,1,nil,e,tp) end 
	local g=Duel.SelectTarget(tp,c43480025.pspfil,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c43480025.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end 
end  



