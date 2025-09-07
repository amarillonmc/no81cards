--虫巢地图
function c7449157.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c7449157.target)
	e1:SetOperation(c7449157.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7449157,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,7449157)
	e2:SetCondition(c7449157.setcon)
	e2:SetTarget(c7449157.settg)
	e2:SetOperation(c7449157.setop)
	c:RegisterEffect(e2)
end
function c7449157.efilter(e)
	return (e:GetCode()==EVENT_BATTLE_DESTROYED or e:GetCode()==EVENT_DAMAGE) and e:IsHasType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_TRIGGER_F) and e:IsHasRange(LOCATION_HAND)
end
function c7449157.chkfilter(c)
	return c:IsOriginalEffectProperty(c7449157.efilter) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c7449157.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local dg=Duel.GetMatchingGroup(c7449157.chkfilter,tp,LOCATION_DECK,0,nil)
		return dg:GetClassCount(Card.GetCode)>=3
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c7449157.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c7449157.chkfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<3 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
	if #cg==0 then return end
	Duel.ConfirmCards(1-tp,cg)
	local tc=cg:RandomSelect(1-tp,1):GetFirst()
	if tc and tc:IsAbleToHand() then
		tc:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		cg:RemoveCard(tc)
	end
	Duel.SendtoGrave(cg,REASON_EFFECT)
end
function c7449157.cfilter(c)
	return bit.band(c:GetPreviousRaceOnField(),RACE_INSECT)~=0
end
function c7449157.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c7449157.cfilter,1,nil)
end
function c7449157.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c7449157.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end
