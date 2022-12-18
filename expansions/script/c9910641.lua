--真空破碎龙
function c9910641.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),12,2)
	c:EnableReviveLimit()
	--banish extra
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c9910641.excost)
	e1:SetTarget(c9910641.extg)
	e1:SetOperation(c9910641.exop)
	c:RegisterEffect(e1)
end
function c9910641.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9910641.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_EXTRA,3,nil) end
end
function c9910641.rmfilter1(c,race)
	return c:IsFaceup() and c:IsRace(race) and c:IsAbleToRemove()
end
function c9910641.rmfilter2(c,att)
	return c:IsAttribute(att) and c:IsAbleToRemove()
end
function c9910641.exop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_EXTRA,nil)
	if g:GetCount()<3 then return end
	local rg=g:RandomSelect(tp,3)
	Duel.ConfirmCards(tp,rg)
	local sg=rg:Filter(Card.IsAbleToRemove,nil)
	if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(9910641,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local fc=sg:Select(tp,1,1,nil):GetFirst()
		local sg1=Group.FromCards(fc)
		Duel.ConfirmCards(1-tp,fc)
		local rg1=Duel.GetMatchingGroup(c9910641.rmfilter1,tp,0,LOCATION_MZONE,nil,fc:GetRace())
		sg1:Merge(rg1)
		Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)
		sg:RemoveCard(fc)
	end
	if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(9910641,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sc=sg:Select(tp,1,1,nil):GetFirst()
		local sg2=Group.FromCards(sc)
		Duel.ConfirmCards(1-tp,sc)
		local rg2=Duel.GetMatchingGroup(c9910641.rmfilter2,tp,0,LOCATION_GRAVE,nil,sc:GetAttribute())
		sg2:Merge(rg2)
		Duel.Remove(sg2,POS_FACEUP,REASON_EFFECT)
		sg:RemoveCard(sc)
	end
	if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(9910641,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(tc:GetBaseAttack())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
		end
	end
	Duel.ShuffleExtra(1-tp)
end
