--孽驱君主 玛门
function c10700676.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	--ritual summon activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(10700676,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCost(c10700676.cost)
	e0:SetTarget(c10700676.target)
	e0:SetOperation(c10700676.activate)
	c:RegisterEffect(e0) 
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700676,2))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,10700676)
	e1:SetTarget(c10700676.thtg)
	e1:SetOperation(c10700676.thop)
	c:RegisterEffect(e1)   
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700676,3))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,10700677)
	e2:SetCondition(c10700676.drcon)
	e2:SetTarget(c10700676.drtg)
	e2:SetOperation(c10700676.drop)
	c:RegisterEffect(e2) 
end
function c10700676.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	Duel.SendtoExtraP(e:GetHandler(),nil,REASON_COST)
end
function c10700676.dfilter(c)
	return c:IsFaceup() and c:IsAbleToGrave() and c:IsLevelAbove(1) 
end
function c10700676.filter(c,e,tp)
	return c:IsRace(RACE_FIEND) or c:IsAttribute(ATTRIBUTE_FIRE)
end
function c10700676.rcheck(tp,g,c)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=99
end
function c10700676.rgcheck(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=99
end
function c10700676.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local dg=Duel.GetMatchingGroup(c10700676.dfilter,tp,LOCATION_EXTRA,0,nil)
		aux.RCheckAdditional=c10700676.rcheck
		aux.RGCheckAdditional=c10700676.rgcheck
		local res=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,c10700676.filter,e,tp,mg,dg,Card.GetLevel,"Greater")
		aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c10700676.activate(e,tp,eg,ep,ev,re,r,rp)
	local m=Duel.GetRitualMaterial(tp)
	local dg=Duel.GetMatchingGroup(c10700676.dfilter,tp,LOCATION_EXTRA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.RCheckAdditional=c10700676.rcheck
	aux.RGCheckAdditional=c10700676.rgcheck
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,c10700676.filter,e,tp,m,dg,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		local mg=m:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(dg)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10700676,1))
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
function c10700676.thfilter(c)
	return c:IsSetCard(0x7cb) and c:IsAbleToHand()
end
function c10700676.thfilter1(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c10700676.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local b1=Duel.IsExistingMatchingCard(c10700676.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		local b2=Duel.IsExistingMatchingCard(c10700676.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
			and e:GetHandler():GetSequence()>4
		return b1 or b2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10700676.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10700676.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	if e:GetHandler():GetSequence()>4 then
		local eg=Duel.GetMatchingGroup(c10700676.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		g:Merge(eg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=g:Select(tp,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c10700676.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA+LOCATION_HAND)
end
function c10700676.drfilter(c)
	return c:IsType(TYPE_RITUAL) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToDeck()
end
function c10700676.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c10700676.drfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c10700676.drfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c10700676.drfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10700676.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end