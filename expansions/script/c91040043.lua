--外道魔之狼王
local m=91040043
local cm=c91040043
function c91040043.initial_effect(c)
aux.AddCodeList(c,35405755)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEUP,1)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,m+100)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_RELEASE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTarget(cm.rthtg)
	e4:SetOperation(cm.rthop)
	c:RegisterEffect(e4)
end
function cm.spcon(e,c)
	 if c==nil then return true end
	return  Duel.GetLocationCount(1-c:GetControler(),LOCATION_MZONE)>0
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ts=e:GetHandler():GetOwner()
	local tc=Duel.SelectMatchingCard(ts,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
		 local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(m,0))
		e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetRange(LOCATION_MZONE) 
		e2:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_CLIENT_HINT)
		e2:SetCountLimit(1)
		e2:SetTarget(cm.thtg2)
		e2:SetOperation(cm.thop2)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		tc:RegisterEffect(e1,true)
end
function cm.spfilter(c)
	return  aux.IsCodeListed(c,35405755) and c:IsAbleToHand()
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		if Duel.SelectYesNo(1-tp,aux.Stringid(m,1)) then  Duel.ConfirmDecktop(1-tp,3)
		local g2=Duel.GetDecktopGroup(1-tp,3)
			if g2:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
				local sg=g2:Select(1-tp,1,1,nil)
				if sg:GetFirst():IsAbleToHand() then
					Duel.SendtoHand(sg,nil,REASON_EFFECT)
					Duel.ConfirmCards(tp,sg)
					Duel.ShuffleHand(1-tp)
				else
					Duel.SendtoGrave(sg,REASON_RULE)
				end
				Duel.ShuffleDeck(1-tp)
			end
		end
	end
end
function cm.rthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_ONFIELD)
end
function cm.rthop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end