--S.B.系统 幸存者
local s,id,o=GetID()
function s.initial_effect(c)
	--ss
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,id)
	--e2:SetCondition(s.remcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id+114514)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end

function s.rmfilter(c)
	return c:IsSetCard(0x3d70) and c:IsAbleToRemove() and c:IsFaceup()
end

function s.sp1filter(c,e,tp)
	return c:IsSetCard(0x3d70) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end

function s.sp2filter(c,e,tp)
	return c:IsSetCard(0x3d70) and c:IsFaceup() and c:IsAbleToHand()
end

function s.sp3filter(c,e,tp)
	return c:IsSetCard(0x3d70) and c:IsFaceup() 
		and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false) )
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return 
		( Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and  Duel.IsExistingTarget(s.sp1filter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
		) or 
		Duel.IsExistingTarget(s.sp2filter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
		and Duel.IsExistingTarget(s.rmfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
	end
		
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	
	local g1 = Group.CreateGroup()
	
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		g1 = Duel.SelectTarget(tp,s.sp3filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	else
		g1 = Duel.SelectTarget(tp,s.sp2filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND,g1,1,0,0)
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,s.rmfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g2,1,0,LOCATION_GRAVE)
	
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local ex1,tg1=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	local ex2,tg2=Duel.GetOperationInfo(0,CATEGORY_REMOVE)
	
	local tc=tg1:GetFirst()
	if tc:IsRelateToEffect(e) then
		--if aux.NecroValleyNegateCheck(tc) then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
	
	if tg2:GetFirst():IsRelateToEffect(e) then
		Duel.Remove(tg2,POS_FACEUP,REASON_EFFECT)
	end


end




