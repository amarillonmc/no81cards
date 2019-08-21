--凯恩之书
function c10121010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetDescription(aux.Stringid(10121010,0))
	e1:SetCountLimit(1,10121010+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c10121010.target)
	e1:SetOperation(c10121010.activate)
	c:RegisterEffect(e1) 
end
function c10121010.mfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and not c:IsType(TYPE_TOKEN)
end
function c10121010.xyzfilter(c,mg)
	return (c:IsSetCard(0xa331) or c:IsSetCard(0xc331)) and c:IsXyzSummonable(mg)
end
function c10121010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c10121010.mfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,nil)
	if chk==0 then return true end
	local op=0
Debug.Message("1")
	if Duel.IsExistingMatchingCard(c10121010.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g) then
	   op=Duel.SelectOption(tp,aux.Stringid(10121010,1),aux.Stringid(10121010,2))
	else
	   op=Duel.SelectOption(tp,aux.Stringid(10121010,2))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	else
		e:SetCategory(0)
	end
end
function c10121010.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		local g=Duel.GetMatchingGroup(c10121010.mfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,nil)
		local xyzg=Duel.GetMatchingGroup(c10121010.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
		if xyzg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
			rscf.AddXyzProcedureLevelFree_Special_Overlay=true
			Duel.XyzSummon(tp,xyz,g,1,3)
		end
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(10121010)
		e1:SetTargetRange(0,LOCATION_MZONE)
		--e1:SetCondition(c10121010.con)
		e1:SetTarget(c10121010.tg)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c10121010.con(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),10121010)<=0
end
function c10121010.tg(e,c)
	return not c:IsType(TYPE_TOKEN)
end


