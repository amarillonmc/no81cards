--纳米飞行器 摄界星帆号
function c9910663.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910663)
	e1:SetCondition(c9910663.spcon)
	e1:SetTarget(c9910663.sptg)
	e1:SetOperation(c9910663.spop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910664)
	e2:SetCost(c9910663.spcost2)
	e2:SetTarget(c9910663.sptg2)
	e2:SetOperation(c9910663.spop2)
	c:RegisterEffect(e2)
end
function c9910663.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c9910663.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9910663.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9910663.costfilter(c,e,tp)
	return c:IsDiscardable() and Duel.IsExistingMatchingCard(c9910663.spfilter,tp,LOCATION_HAND,0,1,c,e,tp)
end
function c9910663.spfilter(c,e,tp)
	return c:IsLevelBelow(9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910663.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c9910663.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		if e:GetLabel()~=0 then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(c9910663.costfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		else
			return Duel.IsExistingMatchingCard(c9910663.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		end
	end
	if e:GetLabel()~=0 then
		e:SetLabel(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(tp,c9910663.costfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9910663.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,c9910663.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
		if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0
			and c:IsFaceup() and tc:IsFaceup() and c:IsRelateToEffect(e) and not tc:IsLevel(c:GetLevel()) then
			local g=Group.FromCards(c,tc)
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910663,0))
			local sg=g:Select(tp,1,1,nil)
			local sc=sg:GetFirst()
			g:RemoveCard(sc)
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(sc:GetLevel())
			g:GetFirst():RegisterEffect(e1)
		end
	end
end
