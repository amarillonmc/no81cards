--孽驱君主 贝利尔
function c10700679.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	--ritual summon activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(10700679,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCost(c10700679.cost)
	e0:SetTarget(c10700679.target)
	e0:SetOperation(c10700679.activate)
	c:RegisterEffect(e0)  
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700679,2))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,10700679)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c10700679.thcost)
	e1:SetTarget(c10700679.thtg)
	e1:SetOperation(c10700679.thop)
	c:RegisterEffect(e1)   
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700679,4))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c10700679.discon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10700679.distg)
	e2:SetOperation(c10700679.disop)
	c:RegisterEffect(e2) 
end
function c10700679.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	Duel.SendtoExtraP(e:GetHandler(),nil,REASON_COST)
end
function c10700679.dfilter(c)
	return c:IsFaceup() and c:IsAbleToGrave() and c:IsLevelAbove(1) 
end
function c10700679.filter(c,e,tp)
	return c:IsRace(RACE_FIEND) or c:IsAttribute(ATTRIBUTE_WATER)
end
function c10700679.rcheck(tp,g,c)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=99
end
function c10700679.rgcheck(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=99
end
function c10700679.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local dg=Duel.GetMatchingGroup(c10700679.dfilter,tp,LOCATION_EXTRA,0,nil)
		aux.RCheckAdditional=c10700679.rcheck
		aux.RGCheckAdditional=c10700679.rgcheck
		local res=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,c10700679.filter,e,tp,mg,dg,Card.GetLevel,"Greater")
		aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c10700679.activate(e,tp,eg,ep,ev,re,r,rp)
	local m=Duel.GetRitualMaterial(tp)
	local dg=Duel.GetMatchingGroup(c10700679.dfilter,tp,LOCATION_EXTRA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.RCheckAdditional=c10700679.rcheck
	aux.RGCheckAdditional=c10700679.rgcheck
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,c10700679.filter,e,tp,m,dg,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		local mg=m:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(dg)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10700679,1))
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
function c10700679.cfilter(c,tp)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c10700679.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700679.cfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10700679.cfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetAttribute())
	Duel.SendtoGrave(g,REASON_COST)
end
function c10700679.thfilter(c,att)
	return c:IsType(TYPE_RITUAL) and c:IsAttribute(att) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10700679.thtg(e,tp,eg,ep,ev,re,r,rp,chk,att)
	local att=e:GetLabel()
	if chk==0 then return true end
	if e:GetHandler():GetSequence()>4 and Duel.IsExistingMatchingCard(c10700679.thfilter,tp,LOCATION_DECK,0,1,nil,att) then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	end
end
function c10700679.thop(e,tp,eg,ep,ev,re,r,rp,g,att)
	local att=e:GetLabel()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_EXTRA,0)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_RITUAL))
	e1:SetValue(att)
	Duel.RegisterEffect(e1,tp)
	if Duel.IsExistingMatchingCard(c10700679.thfilter,tp,LOCATION_DECK,0,1,nil,att)
			and e:GetHandler():GetSequence()>4
			and Duel.SelectYesNo(tp,aux.Stringid(10700679,3)) then
			  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			  local sg=Duel.SelectMatchingCard(tp,c10700679.thfilter,tp,LOCATION_DECK,0,1,1,nil,att)
			  if sg:GetCount()>0 then
				 Duel.SendtoHand(sg,nil,REASON_EFFECT)
				 Duel.ConfirmCards(1-tp,sg)
			  end
	end
end
function c10700679.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==1-tp and re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER)
end
function c10700679.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsCanTurnSet() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,1,0,0)
end
function c10700679.disop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.ChangePosition(eg,POS_FACEDOWN_DEFENSE)
	end
end