--赤之机动战士 扎古
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,s.ffilter,3,true)
	aux.AddCodeList(c,11771190)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1101)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.IsExistingMatchingCard(function(c) return c:IsCode(11771190) and c:IsFaceup() end,tp,LOCATION_ONFIELD,0,1,nil)
	end)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1190)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function s.ffilter(c,fc,sub,mg,sg)
	return not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()) and c:IsRace(RACE_MACHINE)
end
function s.filter(c,tp)
	local atk=c:GetAttack()
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_FUSION) and atk>=0 and Duel.IsExistingMatchingCard(s.filter2,tp,0,LOCATION_MZONE,1,nil,atk)
end
function s.filter2(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	local g2=Duel.GetMatchingGroup(s.filter2,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,#g2,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(s.filter2,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function s.thfilter1(c)
	return c:IsCode(11771190) and c:IsAbleToHand() and c:IsFaceup()
end
function s.thfilter2(c)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToHand() and c:IsFaceup()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) 
	and Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.check(g)
	return g:IsExists(Card.IsCode,1,nil,11771190) and g:IsExists(Card.IsRace,1,nil,RACE_MACHINE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter1),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if #g1<=0 or #g2<=0 then return end
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g1:SelectSubGroup(tp,s.check,false,2,2)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end