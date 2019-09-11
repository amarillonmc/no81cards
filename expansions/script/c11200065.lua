--因幡帝
function c11200065.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11200065,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,11200065)
	e1:SetCondition(c11200065.con1)
	e1:SetTarget(c11200065.tg1)
	e1:SetOperation(c11200065.op1)
	c:RegisterEffect(e1)
--
end
--
c11200065.xig_ihs_0x132=1
c11200065.xig_ihs_0x133=1
--
function c11200065.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
--
function c11200065.tfilter1(c,e,tp)
	return c:IsType(TYPE_MONSTER)
		and (c:IsSetCard(0x621) or c:IsCode(11200019))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11200065.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.GetMZoneCount(tp)>1
		and Duel.IsExistingMatchingCard(c11200065.tfilter1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp)
	local b2=Duel.IsPlayerCanDraw(tp,1)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (b1 or b2) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
--
function c11200065.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local off=1
		local ops={}
		local opval={}
		local b1=Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c11200065.tfilter1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp)
		local b2=Duel.IsPlayerCanDraw(tp,1)
		if b1 then
			ops[off]=aux.Stringid(11200065,1)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(11200065,2)
			opval[off-1]=2
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		local sel=opval[op]
		if sel==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectMatchingCard(tp,c11200065.tfilter1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
		if sel==2 then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
--
