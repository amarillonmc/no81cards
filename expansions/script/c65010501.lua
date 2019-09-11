--URBEX-组织指挥家
function c65010501.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	 --tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,65010501)
	e1:SetCost(c65010501.cost)
	e1:SetTarget(c65010501.tg)
	e1:SetOperation(c65010501.op)
	c:RegisterEffect(e1)
end
c65010501.setname="URBEX"
function c65010501.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,5)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==5
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c65010501.thfilter(c)
	return c:IsFacedown() and c:IsAbleToGrave()
end
function c65010501.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65010501.thfilter,tp,LOCATION_REMOVED,0,3,nil) end
end
function c65010501.gfil(c)
	return c.setname=="URBEX" and c:IsLocation(LOCATION_GRAVE)
end
function c65010501.spfil(c,e,tp)
	return c.setname=="URBEX" and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65010501.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local gg=Duel.GetMatchingGroup(c65010501.thfilter,tp,LOCATION_REMOVED,0,nil)
	local g=gg:RandomSelect(tp,3)
	if g:GetCount()==3 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
		local sg=g:Filter(c65010501.gfil,nil)
		if sg:GetCount()>0 and Duel.IsExistingMatchingCard(c65010501.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
			local spg=Duel.SelectMatchingCard(tp,c65010501.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			spg:AddCard(e:GetHandler())
			Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end