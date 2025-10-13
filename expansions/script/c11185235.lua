--虹龍·海龙
function c11185235.initial_effect(c)
	c:EnableCounterPermit(0x452)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x453),1,1)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11185235,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,11185235)
	e1:SetTarget(c11185235.sptg)
	e1:SetOperation(c11185235.spop)
	c:RegisterEffect(e1)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11185235,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11185235+1)
	e2:SetTarget(c11185235.ptg)
	e2:SetOperation(c11185235.pop)
	c:RegisterEffect(e2)
end
function c11185235.spfilter(c,e,tp)
	return c:IsSetCard(0x453) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11185235.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11185235.spfilter,tp,0x32,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x32)
end
function c11185235.thfilter(c)
	return c:IsSetCard(0x453) and c:IsAbleToHand() and c:IsFaceupEx()
end
function c11185235.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11185235.spfilter),tp,0x32,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
			local b1=Duel.IsCanRemoveCounter(tp,1,0,0x452,2,REASON_EFFECT)
			local b2=Duel.IsExistingMatchingCard(c11185235.thfilter,tp,0x30,0,1,nil)
			if b1 and b2 and Duel.SelectYesNo(tp,aux.Stringid(11185235,0)) then
				if not Duel.RemoveCounter(tp,1,0,0x452,2,REASON_COST) then return end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=Duel.SelectMatchingCard(tp,c11185235.thfilter,tp,0x30,0,1,1,nil)
				if sg:GetCount()>0 then
					Duel.HintSelection(sg)
					Duel.SendtoHand(sg,nil,0x40)
				end
			end
		end
	end
end
function c11185235.pfilter(c)
	if not c:IsSetCard(0x453) then return end
	local seq=c:GetSequence()
	local tp=c:GetControler()
	return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
		or (seq==5 and Duel.CheckLocation(tp,LOCATION_MZONE,1))
		or (seq==6 and Duel.CheckLocation(tp,LOCATION_MZONE,3))
end
function c11185235.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c11185235.pfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c11185235.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sc=Duel.SelectMatchingCard(tp,c11185235.pfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if sc then
		local seq=sc:GetSequence()
		if seq>4 then 
			if seq==5 and Duel.CheckLocation(tp,LOCATION_MZONE,1) then Duel.MoveSequence(sc,1) return end
			if seq==6 and Duel.CheckLocation(tp,LOCATION_MZONE,3) then Duel.MoveSequence(sc,3) return end
		end
		local flag=0
		if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=flag|(1<<(seq-1)) end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=flag|(1<<(seq+1)) end
		if flag==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,~flag)
		local nseq=math.log(s,2)
		Duel.MoveSequence(sc,nseq)
	end
end