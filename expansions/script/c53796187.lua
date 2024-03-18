local s,id=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(id)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return not e:GetHandler():IsPublic()end)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetDescription(aux.Stringid(id,0))
		ge1:SetType(EFFECT_TYPE_QUICK_O)
		ge1:SetCode(EVENT_FREE_CHAIN)
		ge1:SetRange(LOCATION_HAND)
		ge1:SetHintTiming(TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
		ge1:SetCost(s.cost)
		ge1:SetTarget(s.target)
		ge1:SetOperation(s.activate)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		ge3:SetTargetRange(LOCATION_HAND,0)
		ge3:SetCondition(function(e)return Duel.IsExistingMatchingCard(function(c)return c:IsHasEffect(id)end,e:GetHandlerPlayer(),LOCATION_HAND,0,1,nil)end)
		ge3:SetTarget(function(e,c)return c:IsType(TYPE_EFFECT)end)
		ge3:SetLabelObject(ge1)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge3:Clone()
		Duel.RegisterEffect(ge4,1)
	end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c)return c:IsHasEffect(id)end,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local tc=Duel.SelectMatchingCard(tp,function(c)return c:IsHasEffect(id)end,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
	tc:RegisterEffect(e1)
end
function s.hspcheck(g,c,ft)
	--Duel.SetSelectedCard(g)
	return #g<ft and g:GetSum(Card.GetRitualLevel,c)==c:GetLevel()
end
function s.filter(c,e,tp,m)
	if not c:IsType(TYPE_MONSTER) then return false end
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_TYPE)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(TYPE_RITUAL)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EFFECT_REMOVE_TYPE)
	e1:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e1)
	local res=false
	if c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then
		if c.mat_filter then m=m:Filter(c.mat_filter,nil,tp) end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		aux.GCheckAdditional=function(sg)return sg:GetSum(Card.GetRitualLevel,c)<=c:GetLevel() end
		res=m:CheckSubGroup(s.hspcheck,1,#m,c,ft)
		aux.GCheckAdditional=nil
	end
	e0:Reset()
	e1:Reset()
	return res
end
function s.matfilter(c,e,tp)
	return c:IsCode(id+1,id+2,id+3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local mg=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_DECK,0,nil,e,tp)
		return #mg>0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	::cancel::
	local mg=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_DECK,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg):GetFirst()
	if tc then
		local c=e:GetHandler()
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_ADD_TYPE)
		e0:SetValue(TYPE_RITUAL)
		e0:SetReset(RESET_EVENT+0xff0000)
		tc:RegisterEffect(e0)
		local e0_1=e0:Clone()
		e0_1:SetCode(EFFECT_REMOVE_TYPE)
		e0_1:SetValue(TYPE_NORMAL)
		tc:RegisterEffect(e0_1)
		if tc.mat_filter then mg=mg:Filter(tc.mat_filter,nil,tp) end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		aux.GCheckAdditional=function(sg)return sg:GetSum(Card.GetRitualLevel,tc)<=tc:GetLevel() end
		local mat=mg:SelectSubGroup(tp,s.hspcheck,false,1,#mg,tc,ft)
		aux.GCheckAdditional=nil
		if not mat then goto cancel end
		tc:SetMaterial(mat)
		Duel.SpecialSummon(mat,0,tp,tp,false,false,POS_FACEUP)
		mat:ForEach(Card.CreateRelation,tc,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		Duel.BreakEffect()
		if Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP) then
			if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_CANNOT_ATTACK)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			end
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_SINGLE)
			e6:SetCode(EFFECT_SELF_DESTROY)
			e6:SetCondition(s.descon)
			e6:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e6,true)
			Duel.SpecialSummonComplete()
			tc:CompleteProcedure()
		end
	end
end
function s.descon(e)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	return not mg:IsExists(Card.IsRelateToCard,1,nil,c)
end
