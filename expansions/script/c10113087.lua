--樱花剑
function c10113087.initial_effect(c)
	c:SetSPSummonOnce(10113087) 
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c10113087.spcon)
	e1:SetOperation(c10113087.spop)
	c:RegisterEffect(e1) 
	e1:SetValue(SUMMON_VALUE_SELF)  
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10113087,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCost(c10113087.recost)
	e2:SetCondition(c10113087.recon)
	e2:SetTarget(c10113087.retg)
	e2:SetOperation(c10113087.reop)
	c:RegisterEffect(e2)
end
function c10113087.cfilter(c,g)
	local tg=g:Clone()
	local tc=tg:GetFirst()
	while tc do
		  if c:IsRace(tc:GetRace()) then return false end
	tc=tg:GetNext()
	end
	return true
end
function c10113087.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,c)
	if chk==0 then return g:GetCount()>0 and Duel.IsExistingMatchingCard(c10113087.cfilter,tp,LOCATION_DECK,0,1,c,g)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10113087.cfilter,tp,LOCATION_DECK,0,1,1,c,g)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetAttack())
end
function c10113087.reop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c10113087.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabel())
end
function c10113087.recon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF 
end
--mdzz with some fuck card has 2 or more races (oh ,,,,,I have 2 card like this....XD)
function c10113087.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local exc=(c:IsLocation(LOCATION_HAND) and not c:IsAbleToGraveAsCost()) and c or nil
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0 and g:GetClassCount(Card.GetRace)>=3
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,exc)
end
function c10113087.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local exc=(c:IsLocation(LOCATION_HAND) and not c:IsAbleToGraveAsCost()) and c or nil
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,exc)
end
