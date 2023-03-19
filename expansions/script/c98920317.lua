--森罗守护神 山精
function c98920317.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,2,c98920317.ovfilter,aux.Stringid(98920317,0),99,c98920317.xyzop)
	c:EnableReviveLimit()
--deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920317,0))
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98920317)
	e1:SetCondition(c98920317.zcon)
	e1:SetCost(c98920317.atkcost)
	e1:SetTarget(c98920317.target)
	e1:SetOperation(c98920317.operation)
	c:RegisterEffect(e1)
end
function c98920317.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x90) and c:IsType(TYPE_XYZ) and not c:IsCode(98920317)
end
function c98920317.zcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
end
function c98920317.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,98920317)==0 end
	Duel.RegisterFlagEffect(tp,98920317,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c98920317.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98920317.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ac=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
		return ac>0 and Duel.IsPlayerCanDiscardDeck(tp,ac)
	end
end
function c98920317.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if ac==0 or not Duel.IsPlayerCanDiscardDeck(tp,ac) then return end
	Duel.ConfirmDecktop(tp,ac)
	local g=Duel.GetDecktopGroup(tp,ac)
	local sg=g:Filter(Card.IsRace,nil,RACE_PLANT)
	if sg:GetCount()>0 then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REVEAL)
	end
	ac=ac-sg:GetCount()
	if ac>0 and sg:GetCount()>0 then
		for i=1,ac do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.SendtoHand(mg:GetFirst(),nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if sg:GetCount()==0 then
		Duel.ShuffleDeck(tp)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ac*200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
   end
end