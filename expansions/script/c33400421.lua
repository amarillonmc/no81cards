--AST 冈峰美纪惠 校服
function c33400421.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33400421)
	e1:SetCondition(c33400421.spcon)   
	e1:SetTarget(c33400421.sptg)
	e1:SetOperation(c33400421.spop)
	c:RegisterEffect(e1)
	--To Hand
	 local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_LEAVE_FIELD_P)
	e0:SetOperation(c33400421.thp)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400421,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,33400421+10000)
	e2:SetLabelObject(e0)
	e2:SetCondition(c33400421.thcon)
	e2:SetTarget(c33400421.thtg)
	e2:SetOperation(c33400421.thop)
	c:RegisterEffect(e2)
end
function c33400421.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x9343) and c:IsType(TYPE_MONSTER)
end
function c33400421.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x6343)
end
function c33400421.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c33400421.cfilter1,tp,LOCATION_ONFIELD,0,1,nil) and 
   Duel.IsExistingMatchingCard(c33400421.cfilter2,tp,LOCATION_ONFIELD,0,1,nil)
end
function c33400421.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c33400421.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x341) and Duel.IsExistingMatchingCard(c33400421.filter,tp,LOCATION_ONFIELD,0,1,nil,e,tp) then
		if  Duel.IsExistingMatchingCard(Card.IsSetCard,tp,0,LOCATION_MZONE,1,nil,0x341)   
		or (  Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and 
			(Duel.IsExistingMatchingCard(c33400421.cccfilter1,tp,LOCATION_ONFIELD,0,1,nil) or 
			Duel.IsExistingMatchingCard(c33400421.cccfilter2,tp,LOCATION_MZONE,0,1,nil))
		  ) then 
			if Duel.SelectYesNo(tp,aux.Stringid(33400421,0)) then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local tc=Duel.SelectMatchingCard(tp,c33400421.filter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)   
				   Duel.Release(tc,REASON_EFFECT)
				   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				   local tc2=Duel.SelectMatchingCard(tp,c33400421.tfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
				   Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
				
			end
		end
	end
end
function c33400421.tfilter(c,e,tp)
	return c:IsSetCard(0x9343) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33400421.filter(c,e,tp)
	return  c:IsSetCard(0x6343) or c:IsSetCard(0x9343) and c:IsReleasable()
		and Duel.IsExistingMatchingCard(c33400421.tfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
end

function c33400421.thp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zg=e:GetHandler():GetEquipGroup()
	if zg:IsExists(Card.IsSetCard,1,nil,0x6343) then ct=1 
	else
	 ct=0 
	end
	e:SetLabel(ct)
end
function c33400421.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local ct=e:GetLabelObject():GetLabel()
	return ct==1 and e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c33400421.thfilter(c)
	return c:IsSetCard(0x9343) and c:IsAbleToHand()
end
function c33400421.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c33400421.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33400421.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c33400421.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33400421.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)  
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	 if (Duel.IsExistingMatchingCard(c33400421.cccfilter1,tp,LOCATION_ONFIELD,0,1,nil) or 
	Duel.IsExistingMatchingCard(c33400421.cccfilter2,tp,LOCATION_MZONE,0,1,nil) 
	)or (e:GetHandler():GetBattleTarget():IsSetCard(0x341)) and Duel.IsExistingMatchingCard(c33400421.thfilter2,tp,LOCATION_GRAVE,0,1,nil)  then
		  if Duel.SelectYesNo(tp,aux.Stringid(33400421,2)) then 
			  local g2=Duel.GetMatchingGroup(c33400421.thfilter2,tp,LOCATION_GRAVE,0,1,nil)
			  local g3=g2:Select(tp,1,1,nil)
			  Duel.SendtoHand(g3,nil,REASON_EFFECT)
		  end
	 end
end
function c33400421.thfilter2(c)
	return c:IsSetCard(0x6343) and c:IsAbleToHand()
end
function c33400421.cccfilter1(c)
	return c:IsCode(33400428) and c:IsFaceup()
end
function c33400421.cccfilter2(c)
	return c:IsCode(33400425) and c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_XYZ)
end