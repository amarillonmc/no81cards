--岚之忍者-云
function c87498033.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x2b),2)
	c:EnableReviveLimit()
	--to hand 
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,87498033) 
	e1:SetCondition(c87498033.thcon)
	e1:SetTarget(c87498033.thtg)
	e1:SetOperation(c87498033.thop)
	c:RegisterEffect(e1)
	--set 
	local e2=Effect.CreateEffect(c)   
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)  
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,17498033)  
	e2:SetTarget(c87498033.settg)
	e2:SetOperation(c87498033.setop)
	c:RegisterEffect(e2)
end
function c87498033.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c87498033.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c87498033.thfil,tp,LOCATION_DECK,0,nil)
	local ht=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)  
	local x=5-ht 
	if chk==0 then return x>0 and g:CheckSubGroup(aux.dncheck,x,x) and Duel.IsPlayerCanSendtoGrave(tp) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,x,tp,LOCATION_DECK) 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,x,tp,LOCATION_ONFIELD+LOCATION_HAND) 
end
function c87498033.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c87498033.thfil,tp,LOCATION_DECK,0,nil)
	local ht=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)  
	local x=5-ht 
	if x>0 and g:CheckSubGroup(aux.dncheck,x,x) then
		local sg=g:SelectSubGroup(tp,false,x,x) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg)   
		if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,x,nil) then 
			Duel.BreakEffect() 
			local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,x,x,nil) 
			Duel.SendtoGrave(dg,REASON_EFFECT) 
		end 
	end
end
function c87498033.ckfil(c,tp) 
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsControler(tp)
end  
function c87498033.setfil(c,tp,eg) 
	return c:IsSSetable() and c:IsSetCard(0x61) and eg:Filter(c87498033.ckfil,nil,tp):IsContains(c)
end 
function c87498033.settg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c87498033.setfil(chkc,tp,eg) end 
	if chk==0 then return Duel.IsExistingTarget(c87498033.setfil,tp,LOCATION_GRAVE,0,1,nil,tp,eg) end 
	local g=Duel.SelectTarget(tp,c87498033.setfil,tp,LOCATION_GRAVE,0,1,1,nil,tp,eg) 
end
function c87498033.setop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1) 
	end 
end





