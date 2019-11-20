--AST 鸢一折纸 应战
function c33400420.initial_effect(c)
	 --special summon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33400420)
	e1:SetCondition(c33400420.spcon)
	e1:SetTarget(c33400420.sptg)
	e1:SetOperation(c33400420.spop)
	c:RegisterEffect(e1)
	--special summon from grave
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(33400420,1))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_EQUIP)
	e0:SetCountLimit(1,33400420+10000)
	e0:SetCondition(c33400420.spcon1)
	e0:SetTarget(c33400420.sptg1)
	e0:SetOperation(c33400420.spop1)
	c:RegisterEffect(e0)
end
function c33400420.spcfilter(c)
	return c:IsSetCard(0x341) and c:IsFaceup()
end
function c33400420.cccfilter1(c)
	return c:IsCode(33400428) and c:IsFaceup()
end
function c33400420.cccfilter2(c)
	return c:IsCode(33400425) and c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c33400420.ccfilter(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and 
   (Duel.IsExistingMatchingCard(c33400420.cccfilter1,tp,LOCATION_ONFIELD,0,1,nil) or 
	Duel.IsExistingMatchingCard(c33400420.cccfilter2,tp,LOCATION_MZONE,0,1,nil) 
	)
end
function c33400420.spcon(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(c33400420.spcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) or 
	c33400420.ccfilter(e,tp,eg,ep,ev,re,r,rp)
end
function c33400420.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c33400420.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	  if  Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then 
			if Duel.IsExistingMatchingCard(c33400420.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler())
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not Duel.IsExistingMatchingCard(c33400420.spcfilter,tp,LOCATION_MZONE,0,1,nil) then
				if  Duel.IsExistingMatchingCard(c33400420.spcfilter,tp,0,LOCATION_MZONE,1,nil)   
				or
				  (  Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and 
					(Duel.IsExistingMatchingCard(c33400420.cccfilter1,tp,LOCATION_ONFIELD,0,1,nil) or 
					Duel.IsExistingMatchingCard(c33400420.cccfilter2,tp,LOCATION_MZONE,0,1,nil) 
					)
				  )
				then
					if Duel.SelectYesNo(tp,aux.Stringid(33400420,0)) then 
					local g=Duel.GetMatchingGroup(c33400420.filter,tp,LOCATION_GRAVE,0,nil,e,tp,e:GetHandler())
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
					local g1=g:Select(tp,1,1,nil)
					local tc=g1:GetFirst()
					Duel.Equip(tp,tc,c)
					end
				end 
		   end
	   end
	end
end
function c33400420.filter(c,e,tp,ec)
	return c:IsSetCard(0x6343)  and c:CheckEquipTarget(ec) and c:CheckUniqueOnField(tp)
end

function c33400420.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSetCard,1,nil,0x6343) or eg:IsExists(Card.IsSetCard,1,nil,0x5343)
end
function c33400420.spfilter1(c,e,tp)
	return  c:IsSetCard(0x5342) or c:IsSetCard(0x9343) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33400420.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33400420.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c33400420.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33400420.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)	
	end
end