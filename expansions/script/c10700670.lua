--孽驱君主 阿斯蒙蒂斯
function c10700670.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	--ritual summon activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(10700670,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCost(c10700670.cost)
	e0:SetTarget(c10700670.target)
	e0:SetOperation(c10700670.activate)
	c:RegisterEffect(e0)
	--attack up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700670,2))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCountLimit(1,10700670)
	e1:SetTarget(c10700670.cttg)
	e1:SetOperation(c10700670.ctop)
	c:RegisterEffect(e1)
	--SearchCard
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700670,3))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,10700671)
	e2:SetCondition(c10700670.thcon)
	e2:SetTarget(c10700670.thtg)
	e2:SetOperation(c10700670.thop)
	c:RegisterEffect(e2)
end
function c10700670.rrfilter(c)
	return c:IsType(TYPE_RITUAL) and (c:IsRace(RACE_FIEND) or c:IsAttribute(ATTRIBUTE_WIND))
end
function c10700670.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	if Duel.SendtoExtraP(e:GetHandler(),nil,REASON_COST)>0 and not Duel.IsExistingMatchingCard(c10700670.rrfilter,tp,LOCATION_EXTRA,0,1,nil) and Duel.IsExistingMatchingCard(c10700670.rrfilter,tp,LOCATION_HAND,0,1,nil) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c10700670.rrfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	end
end
function c10700670.dfilter(c)
	return c:IsFaceup() and c:IsAbleToGrave() and c:IsLevelAbove(1) 
end
function c10700670.filter(c,e,tp)
	return c:IsRace(RACE_FIEND) or c:IsAttribute(ATTRIBUTE_WIND)
end
function c10700670.rcheck(tp,g,c)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=99
end
function c10700670.rgcheck(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=99
end
function c10700670.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local dg=Duel.GetMatchingGroup(c10700670.dfilter,tp,LOCATION_EXTRA,0,nil)
		aux.RCheckAdditional=c10700670.rcheck
		aux.RGCheckAdditional=c10700670.rgcheck
		local res=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,c10700670.filter,e,tp,mg,dg,Card.GetLevel,"Greater")
		aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c10700670.activate(e,tp,eg,ep,ev,re,r,rp)
	local m=Duel.GetRitualMaterial(tp)
	local dg=Duel.GetMatchingGroup(c10700670.dfilter,tp,LOCATION_EXTRA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.RCheckAdditional=c10700670.rcheck
	aux.RGCheckAdditional=c10700670.rgcheck
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,c10700670.filter,e,tp,m,dg,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		local mg=m:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(dg)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10700670,1))
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then
			aux.RCheckAdditional=nil
			aux.RGCheckAdditional=nil
			return
		end
		tc:SetMaterial(mat)
		local dmat=mat:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
		if dmat:GetCount()>0 then
			mat:Sub(dmat)
			Duel.SendtoGrave(dmat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		if mat:GetCount()>0 then
			Duel.ReleaseRitualMaterial(mat)
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
end
function c10700670.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetBattleTarget()
	if chk==0 then return tc and tc:IsRelateToBattle() and tc:IsControlerCanBeChanged() end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0)
	if e:GetHandler():GetSequence()>4 then
	Duel.SetChainLimit(c10700670.chlimit)
	end
end
function c10700670.chlimit(e,ep,tp)
	return tp==ep
end
function c10700670.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc:IsRelateToBattle() then
		Duel.GetControl(tc,tp,PHASE_END,1)
	end
end
function c10700670.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA+LOCATION_HAND)
end
function c10700670.thfilter(c)
	return c:IsSetCard(0x7cb) and c:IsType(TYPE_PENDULUM) and c:IsAbleToExtra()
end
function c10700670.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700670.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10700670.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10700670.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
	end
end