--啸岚寒域 雪境猎手
function c79029068.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029068,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,79029068)
	e1:SetCost(c79029068.thcost)
	e1:SetTarget(c79029068.thtg)
	e1:SetOperation(c79029068.thop)
	c:RegisterEffect(e1) 
	--move 
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,19029068) 
	e2:SetTarget(c79029068.mvtg)
	e2:SetOperation(c79029068.mvop)
	c:RegisterEffect(e2)
end
c79029068.named_with_KarlanTrade=true 
function c79029068.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c79029068.thfil(c)
	return c.named_with_KarlanTrade and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c79029068.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029068.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79029068.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c79029068.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c79029068.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end 
	Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79029068.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end 
	local p=tc:GetControler()
	local seq=tc:GetSequence() 
	if seq<=4 and ((seq>0 and Duel.CheckLocation(p,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(p,LOCATION_MZONE,seq+1))) then 
		local flag=0 
		if seq>0 and Duel.CheckLocation(p,LOCATION_MZONE,seq-1) then flag=bit.replace(flag,0x1,seq-1) end
		if seq<4 and Duel.CheckLocation(p,LOCATION_MZONE,seq+1) then flag=bit.replace(flag,0x1,seq+1) end
		flag=bit.bxor(flag,0xff)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE) 
		local s=0
		if p==tp then 
		s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag) 
		else 
		flag=0
		if seq==0 then 
		flag=bit.bor(flag,65536*4) 
		flag=bit.bor(flag,65536*8) 
		flag=bit.bor(flag,65536*16)
		end 
		if seq==1 then 
		flag=bit.bor(flag,65536*8) 
		flag=bit.bor(flag,65536*16)
		end 
		if seq==2 then 
		flag=bit.bor(flag,65536*1) 
		flag=bit.bor(flag,65536*16)
		end 
		if seq==3 then 
		flag=bit.bor(flag,65536*1) 
		flag=bit.bor(flag,65536*2)
		end 
		if seq==4 then 
		flag=bit.bor(flag,65536*1) 
		flag=bit.bor(flag,65536*2)
		flag=bit.bor(flag,65536*4)
		end 
		s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,flag)	 
		end
		local nseq=0
		if p==tp then 
		if s==1 then nseq=0
		elseif s==2 then nseq=1
		elseif s==4 then nseq=2
		elseif s==8 then nseq=3
		else nseq=4 end 
		else 
		if s==65536 then nseq=0
		elseif s==65536*2 then nseq=1
		elseif s==65536*4 then nseq=2
		elseif s==65536*8 then nseq=3 
		else nseq=4 end 
		end
		Duel.MoveSequence(tc,nseq)
	else
	if c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	if Duel.SelectYesNo(tp,aux.Stringid(79029068,0)) then 
	Duel.Destroy(tc,REASON_EFFECT)
	end
	end
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c79029068.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c79029068.splimit(e,c)
	return not c.named_with_KarlanTrade and c:IsLocation(LOCATION_EXTRA)
end






