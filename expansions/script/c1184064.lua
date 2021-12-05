--缤纷假日
function c1184064.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1184064.tg1)
	e1:SetOperation(c1184064.op1)
	c:RegisterEffect(e1)
--
end
--
function c1184064.BthFilter(c,e,tp)
	return c:IsSetCard(0x3e12) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c1184064.FusFilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c1184064.FusFilter(c,e,tp,tc)
	return Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
		and c:IsSetCard(0x3e12) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c1184064.AthFilter(c)
	return c:IsSetCard(0x3e12) and c:IsType(TYPE_MONSTER)
		and c:GetLevel()>0 and c:IsAbleToHand()
end
function c1184064.RitCheckFilter(sg,lv)
	return sg:GetSum(Card.GetLevel)==lv
end
function c1184064.RitFilter(c,e,tp,mg)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsSetCard(0x3e12)
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	return mg:CheckSubGroup(c1184064.RitCheckFilter,1,#mg,c:GetLevel())
end
function c1184064.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c1184064.BthFilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	local mg=Duel.GetMatchingGroup(c1184064.AthFilter,tp,LOCATION_DECK,0,nil)
	local b2=Duel.IsExistingMatchingCard(c1184064.RitFilter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
	if chk==0 then return (b1 or b2) end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(1184064,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(1184064,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	end
end
function c1184064.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tc=Duel.SelectMatchingCard(tp,c1184064.BthFilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
		if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,c1184064.FusFilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
			if sg:GetCount()<1 then return end
			Duel.SpecialSummon(sg,0,tp,tp,true,true,POS_FACEUP)
		end
	else
		local mg=Duel.GetMatchingGroup(c1184064.AthFilter,tp,LOCATION_DECK,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,c1184064.RitFilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg):GetFirst()
		if tc then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=mg:SelectSubGroup(tp,c1184064.RitCheckFilter,false,1,#mg,tc:GetLevel())
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
			Duel.ShuffleHand(tp)
		end
	end
end
--