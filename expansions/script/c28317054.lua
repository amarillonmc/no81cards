--闪耀的绿宝石 绯田美琴
function c28317054.initial_effect(c)
	--pendulum
	aux.EnablePendulumAttribute(c)
	--shhis pendulum
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28317054,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,28317054)
	e1:SetTarget(c28317054.sptg)
	e1:SetOperation(c28317054.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c28317054.thtg)
	e2:SetOperation(c28317054.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c28317054.cfilter(c,e,tp,ex)
	local ct=0
	if c:IsAbleToHand() then ct=ct+1 end
	if c:IsLocation(LOCATION_SZONE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 then ct=ct+2 end
	if ex==4 then return ct~=0 else
	return ct==ex end
end
function c28317054.tfilter(c,e,tp)
	if not c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) or c:IsFacedown() or not c28317054.cfilter(c,e,tp,4) then return false end
	local g=Group.FromCards(c,e:GetHandler())
	return g:FilterCount(c28317054.cfilter,nil,e,tp,2)~=2 or Duel.GetMZoneCount(tp)>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
end
function c28317054.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c28317054.tfilter(chkc,e,tp) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c28317054.tfilter,tp,LOCATION_ONFIELD,0,1,c,e,tp) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil) and c28317054.cfilter(c,e,tp,4) end
	local g=Duel.GetMatchingGroup(c28317054.tfilter,tp,LOCATION_ONFIELD,0,c,e,tp):Filter(Card.IsCanBeEffectTarget,nil,e)
	if #g==1 then Duel.SetTargetCard(g) else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,c28317054.tfilter,tp,LOCATION_ONFIELD,0,1,1,c,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function c28317054.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Group.FromCards(c,tc)
	if not (c:IsRelateToChain() and tc:IsRelateToChain() and g:FilterCount(c28317054.cfilter,nil,e,tp,4)==2) or not (g:FilterCount(c28317054.cfilter,nil,e,tp,2)~=2 or not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetMZoneCount(tp)>=2) then return end
	local mg=g:Filter(c28317054.cfilter,nil,e,tp,3)--manual
	local g1=g:Filter(c28317054.cfilter,nil,e,tp,1)
	local g2=g:Filter(c28317054.cfilter,nil,e,tp,2)
	if #mg~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tg=mg:FilterSelect(tp,Card.IsAbleToHand,0,#mg,nil)
		mg:Sub(tg)
		if #tg~=0 then g1:Merge(tg) end
		if #mg~=0 then g2:Merge(mg) end
	end
	local res=false
	if #g1~=0 and Duel.SendtoHand(g1,nil,REASON_EFFECT)~=0 and g1:FilterCount(Card.IsLocation,nil,LOCATION_HAND)~=0 then res=true end
	if #g2~=0 and Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)~=0 then res=true end
	if res then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,1,nil)
	if #rg==0 then return end
	Duel.HintSelection(rg)
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
end
function c28317054.thfilter(c)
	return c:IsSetCard(0x283) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28317054.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local res=e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL) and re and 1 or 0
	e:SetLabel(res)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28317054.desfilter(c)
	return c:IsSetCard(0x283) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsAbleToRemove()
end
function c28317054.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c28317054.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not tc or Duel.SendtoHand(tc,nil,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_HAND) then return end
	Duel.ConfirmCards(1-tp,tc)
	if e:GetLabel()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg=Duel.SelectMatchingCard(tp,c28317054.desfilter,tp,LOCATION_DECK,0,1,1,nil)
	if e:GetHandler():IsRelateToEffect(e) then tg:AddCard(e:GetHandler()) end
	Duel.Destroy(tg,REASON_EFFECT,LOCATION_REMOVED)
end
