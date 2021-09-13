--共生试验体 辉煌战姬
function c9910890.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c9910890.ffilter,4,true)
	--atk & def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9910890.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--recycle
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c9910890.thcon)
	e3:SetTarget(c9910890.thtg)
	e3:SetOperation(c9910890.thop)
	c:RegisterEffect(e3)
end
function c9910890.ffilter(c,fc,sub,mg,sg)
	return not sg or sg:FilterCount(aux.TRUE,c)==0 or not sg:IsExists(Card.IsRace,1,c,c:GetRace())
end
function c9910890.atkfilter(c)
	return c:IsFaceup() and c:GetRace()~=0
end
function c9910890.atkval(e,c)
	local g=Duel.GetMatchingGroup(c9910890.atkfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=g:GetClassCount(Card.GetRace)
	return ct*300
end
function c9910890.thcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c9910890.thfilter(c)
	return c:IsFaceup() and aux.IsCodeListed(c,9910871) and c:IsAbleToHand()
end
function c9910890.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910890.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910890,0))
end
function c9910890.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910890.thfilter,tp,LOCATION_REMOVED,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
