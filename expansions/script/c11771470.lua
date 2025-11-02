--自深渊的回归
local s,id,o=GetID()
function c11771470.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DICE+CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+2)
	e2:SetCost(c11771470.cost)
	e2:SetTarget(c11771470.tg)
	e2:SetOperation(c11771470.op)
	c:RegisterEffect(e2)
end
function s.filter(c,e,tp)
	return c:IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_DICE))
end
function s.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
	if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true,POS_FACEUP) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c):Filter(s.filter,nil)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local lv=level_function(c)
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,lv,greater_or_equal)
	local res=mg:CheckSubGroup(aux.RitualCheck,1,lv,tp,c,lv,greater_or_equal)
	aux.GCheckAdditional=nil
	return res
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		return Duel.IsExistingMatchingCard(s.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,s.filter,e,tp,mg1,nil,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	::cancel::
	local mg1=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,s.filter,e,tp,mg1,nil,Card.GetLevel,"Greater")
	local tc=g:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc):Filter(s.filter,nil)
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
		tc:CompleteProcedure()
	end
end
function c11771470.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),0x5,REASON_COST)
	e:GetHandler():CreateEffectRelation(e)
end
function c11771470.tgfilter(c)
	return c:IsAbleToHand()
end
function c11771470.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c11771470.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11771470.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and (c:IsAbleToHand() or c:IsAbleToDeck()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c11771470.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c11771470.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=Duel.TossDice(tp,1)
	if dc==1 or dc==3 or dc==5 then
		if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,1,0x40)>0 and c:IsLocation(0x1) then
			Duel.Draw(tp,1,0x40)
		end
	elseif dc==2 or dc==4 or dc==6 then
		local tc=Duel.GetFirstTarget()
		if c:IsRelateToEffect(e) then
			Duel.SendtoHand(c,nil,0x40)
		end
		if tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,nil,0x40)
		end
	end
end