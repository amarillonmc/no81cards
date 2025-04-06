--邪龙界放
function c75000918.initial_effect(c)
	aux.AddCodeList(c,75000901)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75000918,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,75000918)
	e1:SetTarget(c75000918.target)
	e1:SetOperation(c75000918.activate)
	c:RegisterEffect(e1)  
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75000918,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c75000918.handcon)
	c:RegisterEffect(e2)   
end
c75000918.fusion_effect=true
function c75000918.filter(c,e,tp,mg)
	local ct=c:GetLevel()
	return c:IsType(TYPE_FUSION) and aux.IsCodeListed(c,75000901) and c:CheckFusionMaterial()
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and mg:CheckSubGroup(c75000918.gcheck,1,ct,tp,c,ct)
end
function c75000918.gcheck(g,tp,fc,lv)
	return Duel.GetLocationCountFromEx(tp,tp,g,fc)>0
		and g:FilterCount(Card.IsAbleToGrave,nil)==g:GetCount() and g:GetSum(Card.GetLevel)==lv
end
function c75000918.tyfilter(c)
	return bit.band(c:GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER and c:IsLevelAbove(0)
end
function c75000918.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c75000918.tyfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
		and Duel.IsExistingMatchingCard(c75000918.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c75000918.activate(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	local mg=Duel.GetMatchingGroup(c75000918.tyfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c75000918.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg)
	local tc=g:GetFirst()
	local code=tc:GetCode()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		local ct=tc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=mg:SelectSubGroup(tp,c75000918.gcheck,false,1,ct,tp,tc,ct)
		local cg=sg:Filter(Card.IsFacedown,nil)
		Duel.ConfirmCards(1-tp,cg)
		if Duel.SendtoGrave(sg,REASON_EFFECT)~=0 and sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)~=0 then
			tc:SetMaterial(nil)
			--Duel.BreakEffect()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e1:SetCountLimit(1)
			e1:SetLabel(Duel.GetTurnCount(),code)
			e1:SetCondition(c75000918.spcon)
			e1:SetOperation(c75000918.spop)
			if Duel.GetCurrentPhase()<=PHASE_STANDBY then
				e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
			else
				e1:SetReset(RESET_PHASE+PHASE_STANDBY)
			end
			Duel.RegisterEffect(e1,tp)
		end
	end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0)
		Duel.RegisterEffect(e1,tp)
	end
end
--
function c75000918.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_ONFIELD)~=0
end
--
function c75000918.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75000918.spcon(e,tp,eg,ep,ev,re,r,rp)
	local a,b=e:GetLabel()
	return Duel.GetTurnCount()~=a and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c75000918.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,b)
end
function c75000918.spop(e,tp,eg,ep,ev,re,r,rp)
	local a,b=e:GetLabel()
	Duel.Hint(HINT_CARD,0,75000918)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c75000918.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,b)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	end
end

