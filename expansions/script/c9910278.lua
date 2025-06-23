--星幽特工
function c9910278.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c9910278.matfilter,1,1)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c9910278.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910278)
	e2:SetTarget(c9910278.rmtg)
	e2:SetOperation(c9910278.rmop)
	c:RegisterEffect(e2)
end
function c9910278.matfilter(c)
	return c:IsLinkSetCard(0x3957) and not c:IsLinkCode(9910278)
end
function c9910278.indtg(e,c)
	return e:GetHandler()==c or (c:IsType(TYPE_PENDULUM) and e:GetHandler():GetLinkedGroup():IsContains(c))
end
function c9910278.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(1-tp,3)
	if chk==0 then return Duel.IsPlayerCanRemove(tp) and #g==3 and g:FilterCount(Card.IsAbleToHand,nil,tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_DECK)
end
function c9910278.rmop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)<3 then return end
	Duel.ConfirmDecktop(1-tp,3)
	local g=Duel.GetDecktopGroup(1-tp,3)
	if g:GetCount()>0 then
		local tg=g:Filter(Card.IsAbleToHand,nil,tp)
		if #tg>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil,tp)
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
		end
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT+REASON_REVEAL)
	end
end
