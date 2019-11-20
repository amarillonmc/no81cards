--AST 冈峰美纪惠 请辞
function c33400424.initial_effect(c)
	 --th
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33400424,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,33400424)
	e3:SetCondition(c33400424.thcon)
	e3:SetTarget(c33400424.thtg)
	e3:SetOperation(c33400424.thop)
	c:RegisterEffect(e3)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33400424,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,33400424+10000)
	e1:SetCondition(c33400424.spcon)  
	e1:SetTarget(c33400424.target)
	e1:SetOperation(c33400424.operation)
	c:RegisterEffect(e1)
end
function c33400424.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
		and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0xc343)
end
function c33400424.rthcfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x9343) and c:IsAbleToHand()
		and Duel.IsExistingTarget(c33400424.rthtgfilter,tp,0,LOCATION_ONFIELD,1,c,c)
end
function c33400424.rthtgfilter(c,tc)
	return c:IsAbleToHand() 
end
function c33400424.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 local c=e:GetHandler()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToHand() end
	if chk==0 then  return Duel.IsExistingMatchingCard(c33400424.rthcfilter,tp,LOCATION_ONFIELD,0,1,c,tp)   end   
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,0,0)
end
function c33400424.thop(e,tp,eg,ep,ev,re,r,rp)
	if  not Duel.IsExistingMatchingCard(c33400424.rthcfilter,tp,LOCATION_ONFIELD,0,1,c,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
   local tcnm=1
	 if  (Duel.IsExistingMatchingCard(Card.IsSetCard,tp,0,LOCATION_MZONE,1,nil,0x341) and 
	   not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x341)
		)
	or
	  (not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x341) and
	   Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and 
		(Duel.IsExistingMatchingCard(c33400423.cccfilter1,tp,LOCATION_SZONE,0,1,nil) or 
		Duel.IsExistingMatchingCard(c33400423.cccfilter2,tp,LOCATION_MZONE,0,1,nil))
	  ) then   
		   tcnm=2
	end
	local g1=Duel.SelectMatchingCard(tp,c33400424.rthcfilter,tp,LOCATION_ONFIELD,0,1,1,c,tp)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,tcnm,nil)
	g1:Merge(g2)
	Duel.SendtoHand(g1,nil,REASON_EFFECT)   
end

function c33400424.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x9343)
end
function c33400424.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c33400424.cfilter1,tp,LOCATION_ONFIELD,0,1,nil) 
   
end
function c33400424.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,400)
end
function c33400424.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x9343) or c:IsSetCard(0x6343)
end
function c33400424.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
	local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e0:SetValue(LOCATION_REMOVED)
		e0:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e0,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e1:SetValue(c33400424.cfilter3)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e:GetHandler():RegisterEffect(e1,true)
		 local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e:GetHandler():RegisterEffect(e2,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e:GetHandler():RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e:GetHandler():RegisterEffect(e5,true)
	Duel.SpecialSummonComplete()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tc=Duel.GetMatchingGroup(c33400424.cfilter2,tp,LOCATION_ONFIELD,0,nil) 
	  local tc2=tc:Select(tp,1,1,nil)
		 Duel.Destroy(tc2,REASON_EFFECT)
	end
end
function c33400424.cfilter3(e,c)
	if not c then return false end
	return not c:IsSetCard(0x9343) 
end