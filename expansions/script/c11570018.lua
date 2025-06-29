--魔剑·雷爪咒斩
function c11570018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11570018.target)
	e1:SetOperation(c11570018.activate)
	c:RegisterEffect(e1) 
	--
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11570018)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c11570018.tftg)
	e2:SetOperation(c11570018.tfop)
	c:RegisterEffect(e2)
end
function c11570018.filter(c,e,tp)
	return c:IsSetCard(0x810)
end 
function c11570018.mfilter1(c)
	return c:IsAbleToRemove() and c:IsSetCard(0x810)
end
function c11570018.mfilter2(c)
	return c:IsAbleToGrave() and c:IsSetCard(0x810)
end
function c11570018.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
	if not c:IsType(TYPE_MONSTER) or (filter and not filter(c,e,tp,chk)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local lv=level_function(c)
	Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(c,lv,greater_or_equal)
	local res=mg:CheckSubGroup(Auxiliary.RitualCheck,1,lv,tp,c,lv,greater_or_equal)
	Auxiliary.GCheckAdditional=nil
	return res
end
function c11570018.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsAbleToRemove,nil):Filter(Card.IsSetCard,nil,0x810) 
		local mg1=Duel.GetMatchingGroup(c11570018.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil,c11570018.mfilter1) 
		mg:Merge(mg1) 
		local mg2=Duel.GetMatchingGroup(c11570018.RitualExtraFilter,tp,LOCATION_REMOVED,0,nil,c11570018.mfilter2) 
		return Duel.IsExistingMatchingCard(c11570018.RitualUltimateFilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c11570018.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
	end 
end
function c11570018.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	::cancel::
	local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsAbleToRemove,nil):Filter(Card.IsSetCard,nil,0x810) 
	local mg1=Duel.GetMatchingGroup(aux.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil,c11570018.mfilter1) 
	mg:Merge(mg1) 
	local mg2=Duel.GetMatchingGroup(aux.RitualExtraFilter,tp,LOCATION_REMOVED,0,nil,c11570018.mfilter2) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c11570018.RitualUltimateFilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,c11570018.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if mg2 then
			mg:Merge(mg2)
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat then goto cancel end
		tc:SetMaterial(mat)
		local xmat=mat:Filter(Card.IsLocation,nil,LOCATION_REMOVED) 
		Duel.ReleaseRitualMaterial(mat)
		if xmat:GetCount()>0 then 
			Duel.SendtoGrave(xmat,REASON_EFFECT+REASON_RITUAL)
		end 
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		Duel.BreakEffect() 
		if not Duel.Equip(tp,c,tc) then return end  
		c:CancelToGrave()
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(function(e,c)
		return e:GetOwner()==c end)
		c:RegisterEffect(e1)
	end
end
function c11570018.tffilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x810)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp) and c:CheckActivateEffect(true,true,false)~=nil
end
function c11570018.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c11570018.tffilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c11570018.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c11570018.tffilter,tp,LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc==nil then return end 
	if tc:IsType(TYPE_FIELD) then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	elseif tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end 
	local te=tc:GetActivateEffect()
	local tep=tc:GetControler()
	local condition=te:GetCondition()
	local cost=te:GetCost()
	local target=te:GetTarget()
	local operation=te:GetOperation()  
	Duel.ClearTargetCard()
	e:SetProperty(te:GetProperty())
	Duel.Hint(HINT_CARD,0,tc:GetOriginalCode()) 
	if not tc:IsType(TYPE_CONTINUOUS+TYPE_FIELD) then 
		tc:CancelToGrave(false) 
	end  
	tc:CreateEffectRelation(te)
	if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g and g:GetCount()>0 then 
		local tg=g:GetFirst()
		while tg do
			tg:CreateEffectRelation(te)
			tg=g:GetNext()
		end  
	end 
	if operation then operation(te,tep,eg,ep,ev,re,r,rp) end  
	tc:ReleaseEffectRelation(te)
	if g and g:GetCount()>0 then 
		local tg=g:GetFirst()
		while tg do
			tg:ReleaseEffectRelation(te) 
			tg=g:GetNext()
		end  
	end  
end
