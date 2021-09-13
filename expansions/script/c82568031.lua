--方舟骑士·占星者 星极
function c82568031.initial_effect(c)
	--XYZ summon
	aux.AddXyzProcedure(c,nil,3,2,c82568031.ovfilter,aux.Stringid(82568031,2),2,c82568031.xyzop)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82568031,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,82568031)
	e1:SetCost(c82568031.cost)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c82568031.thtg)
	e1:SetOperation(c82568031.thop)
	c:RegisterEffect(e1)
end
function c82568031.xyzop(e,tp,chk)
	if chk==0 then return  Duel.GetFlagEffect(tp,82568131)==0 end
	Duel.RegisterFlagEffect(tp,82568131,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c82568031.handcon(e)
	return Duel.GetLP(e:GetHandlerPlayer())<=4000
end
function c82568031.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)  end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c82568031.ovfilter(c)
	return c:IsSetCard(0x825) and c:GetCounter(0x5825)>0 
end
function c82568031.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x825)
end
function c82568031.ctfilter(c)
	return c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)
end
function c82568031.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=4  end
end
function c82568031.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=4 then
		Duel.ConfirmDecktop(tp,4)
		local g=Duel.GetDecktopGroup(tp,4)
		if g:GetCount()>0 then
			Duel.DisableShuffleCheck()
			if g:IsExists(c82568031.ctfilter,1,nil) then
			   local ctn=g:Filter(c82568031.ctfilter,nil):GetCount()
			   if e:GetHandler():IsFaceup() and e:GetHandler():IsRelateToEffect(e) 
				then  e:GetHandler():AddCounter(0x5825,ctn)
			   end
			 end
			Duel.BreakEffect()
			if g:IsExists(c82568031.thfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(82568031,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g:FilterSelect(tp,c82568031.thfilter,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
				g:Sub(sg)
			end
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
		end
	end
end