--幽鬼熊 希洛库玛
function c9910266.initial_effect(c)
	c:EnableCounterPermit(0x953)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9910266)
	e1:SetCondition(c9910266.spcon)
	e1:SetOperation(c9910266.spop)
	c:RegisterEffect(e1)
	--add counter / special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER+CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetCountLimit(1,9910267)
	e2:SetCondition(c9910266.ctcon)
	e2:SetTarget(c9910266.cttg)
	e2:SetOperation(c9910266.ctop)
	c:RegisterEffect(e2)
end
function c9910266.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsCanRemoveCounter(c:GetControler(),1,0,0x953,1,REASON_COST)
end
function c9910266.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(tp,1,0,0x953,1,REASON_COST)
end
function c9910266.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c9910266.spfilter(c,e,tp)
	return c:IsLevelAbove(2) and c:IsSetCard(0x953) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910266.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local sel=0
		if c:IsCanAddCounter(0x953,2) then sel=sel+1 end
		if c:IsCanTurnSet() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c9910266.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then
			sel=sel+2
		end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910266,0))
		sel=Duel.SelectOption(tp,aux.Stringid(9910266,1),aux.Stringid(9910266,2))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(9910266,1))
	else
		Duel.SelectOption(tp,aux.Stringid(9910266,2))
	end
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_COUNTER)
		Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x953)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
	end
end
function c9910266.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			c:AddCounter(0x953,2)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetValue(c9910266.efilter)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9910266.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0
			and c:IsRelateToEffect(e) and c:IsFaceup() then
			Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
		end
	end
end
function c9910266.efilter(e,re)
	return re:GetOwner()~=e:GetOwner()
end
