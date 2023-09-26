--影灵衣的仪水返生
function c11533708.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11533708.target)
	e1:SetOperation(c11533708.activate)
	c:RegisterEffect(e1) 
	--recycle 
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(11533708,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED) 
	e2:SetCost(c11533708.rycost) 
	e2:SetTarget(c11533708.rytg1) 
	e2:SetOperation(c11533708.ryop1) 
	c:RegisterEffect(e2)  
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(11533708,2))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED) 
	e2:SetCost(c11533708.rycost) 
	e2:SetTarget(c11533708.rytg2) 
	e2:SetOperation(c11533708.ryop2) 
	c:RegisterEffect(e2)  
end
function c11533708.filter(c,e,tp)
	return c:IsSetCard(0xb4,0x3a) 
end 
function c11533708.mfilter1(c)  
	return c:IsSetCard(0xb4,0x3a)  
end
function c11533708.mfilter2(c)  
	return c:IsFaceup() 
end
function c11533708.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsOnField,nil)   
		local mg2=Duel.GetMatchingGroup(aux.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil,c11533708.mfilter1) 
		local mg3=Duel.GetMatchingGroup(aux.RitualExtraFilter,tp,0,LOCATION_MZONE,nil,c11533708.mfilter2) 
		mg2:Merge(mg3)  
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c11533708.filter,e,tp,mg,mg2,Card.GetLevel,"Equal") and Duel.GetFlagEffect(tp,11533708)==0 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE) 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)  
end
function c11533708.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsOnField,nil)   
	local mg2=Duel.GetMatchingGroup(aux.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil,c11533708.mfilter1) 
	local mg3=Duel.GetMatchingGroup(aux.RitualExtraFilter,tp,0,LOCATION_MZONE,nil,c11533708.mfilter2) 
	mg2:Merge(mg3)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,c11533708.filter,e,tp,mg,mg2,Card.GetLevel,"Equal")
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
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure() 
		if tc:IsLevelAbove(1) and Duel.SelectYesNo(tp,aux.Stringid(11533708,0)) then 
			Duel.SetLP(tp,Duel.GetLP(tp)-tc:GetLevel()*300)   
		else 
			Duel.RegisterFlagEffect(tp,11533708,RESET_PHASE+PHASE_END,0,1)  
		end  
	end
end
function c11533708.rycost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(function(c) return c:IsAbleToDeckAsCost() and c:IsSetCard(0xb4,0x3a) end,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end   
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsAbleToDeckAsCost() and c:IsSetCard(0xb4,0x3a) end,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler()) 
	g:AddCard(e:GetHandler()) 
	Duel.SendtoDeck(g,nil,2,REASON_COST)	 
end 
function c11533708.rytg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsAbleToHand() and not c:IsCode(11533708) and c:IsSetCard(0x18e) end,tp,LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE) 
end 
function c11533708.ryop1(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(function(c) return c:IsAbleToHand() and not c:IsCode(11533708) and c:IsSetCard(0x18e) end,tp,LOCATION_GRAVE,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,nil,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg)   
	end 
end  
function c11533708.rytg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsAbleToGrave() and not c:IsCode(11533708) and c:IsSetCard(0xb4) end,tp,LOCATION_REMOVED,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED) 
end 
function c11533708.ryop2(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(function(c) return c:IsAbleToGrave() and not c:IsCode(11533708) and c:IsSetCard(0xb4) end,tp,LOCATION_REMOVED,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoGrave(sg,REASON_EFFECT) 
	end 
end 









