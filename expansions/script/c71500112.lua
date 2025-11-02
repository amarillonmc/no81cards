--典礼术
function c71500112.initial_effect(c)
	aux.AddSetNameMonsterList(c,0x78f1) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,71500112+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c71500112.cost)
	e1:SetTarget(c71500112.target)
	e1:SetOperation(c71500112.activate)
	c:RegisterEffect(e1)
	--counter 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c71500112.cttg)
	e2:SetOperation(c71500112.ctop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(71500112,ACTIVITY_SPSUMMON,c71500112.counterfilter)
end
function c71500112.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) 
end
function c71500112.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(71500112,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c) 
	return c:IsLocation(LOCATION_EXTRA) end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c71500112.filter(c,e,tp)
	return true 
end 
function c71500112.rthfil(c) 
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()  
end 
function c71500112.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp) 
		local mg2=nil 
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,c71500112.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
		   and Duel.IsExistingMatchingCard(c71500112.rthfil,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND) 
end
function c71500112.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	::cancel::
	local mg=Duel.GetRitualMaterial(tp) 
	local mg2=nil 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,1,nil,c71500112.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
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
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP) 
		Duel.BreakEffect()
		local dc=Duel.TossDice(tp,1) 
		if dc and dc>0 and Duel.IsExistingMatchingCard(c71500112.rthfil,tp,LOCATION_DECK,0,1,nil) then 
			local sg=Duel.SelectMatchingCard(tp,c71500112.rthfil,tp,LOCATION_DECK,0,1,dc,nil) 
			Duel.SendtoHand(sg,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,sg) 
		end 
	end
end
function c71500112.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function c71500112.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,0x78f1,1)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_COUNTER_PERMIT|0x78f1) 
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetRange(LOCATION_SZONE)  
		tc:RegisterEffect(e1)  
		tc:AddCounter(0x78f1,1) 
		tc=g:GetNext()
	end
end

