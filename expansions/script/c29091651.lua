--方舟骑士将火照影
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,29008292)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.rfilter(c,lv)
	return (c:IsType(TYPE_RITUAL) and c:IsCode(29008292)) and c:IsLevelBelow(lv-c:GetLevel())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local lp=Duel.GetLP(tp)
		local ct=math.floor(lp/400)
		local mg=Duel.GetRitualMaterial(tp)
		local clv=mg:GetSum(Card.GetLevel)
		local rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.rfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,ct+clv)
		return #rg>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.ofilter(c)
	return c:GetFlagEffect(id)==0
end
function s.hspgcheck(lv)
	return function (g)
			if g:GetSum(Card.GetLevel)<=lv then return true end
			Duel.SetSelectedCard(g)
			return g:CheckWithSumGreater(Card.GetLevel,lv)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	::cancel::
	local lp=Duel.GetLP(tp)
	local ct=math.floor(lp/400)
	local mg=Duel.GetRitualMaterial(tp)
	local clv=mg:GetSum(Card.GetLevel)
	local rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.rfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,ct+clv)
	if #rg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=rg:Select(tp,1,1,nil):GetFirst()
		tc:RegisterFlagEffect(id,RESET_CHAIN,0,1)
		mg=mg:Filter(s.ofilter,nil)
		local lv=tc:GetLevel()
		local b1=true
		local b2=#mg>0
		local off=1
		local ops={}
		local opval={}
		if b1 then
			ops[off]=aux.Stringid(id,0)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(id,1)
			opval[off-1]=2
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		local sel=opval[op]
		if sel==1 then
			Duel.Damage(tp,lv*400,REASON_EFFECT)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			aux.GCheckAdditional=s.hspgcheck(lv)
			local mat=mg:SelectSubGroup(tp,s.hspgcheck,false,1,#mg,lv)
			aux.GCheckAdditional=nil
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
			if #mat==1 and mat:GetFirst():IsHasEffect(EFFECT_RITUAL_LEVEL,tp) then
				Debug.Message("屌毛")
			else
				local clv=mat:GetSum(Card.GetLevel)
				local damlv=lv-clv
				Duel.Damage(tp,damlv*400,REASON_EFFECT)
			end
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
