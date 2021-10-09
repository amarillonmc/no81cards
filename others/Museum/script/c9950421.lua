--恋恋之女仆
function c9950421.initial_effect(c)
--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950421,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e1:SetCondition(c9950421.spcon)
	e1:SetValue(c9950421.spval)
	c:RegisterEffect(e1)
--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950421,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c9950421.cost)
	e1:SetOperation(c9950421.operation)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950421,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9950421)
	e2:SetCondition(c9950421.tgcon)
	e2:SetTarget(c9950421.tgtg)
	e2:SetOperation(c9950421.tgop)
	c:RegisterEffect(e2)
end
function c9950421.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=Duel.GetLinkedZone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c9950421.spval(e,c)
	return 0,Duel.GetLinkedZone(c:GetControler())
end
function c9950421.cfilter(c)
	return  c:IsRace(RACE_PSYCHO) and c:IsFaceup() and not c:IsCode(9950421)
end
function c9950421.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9950421.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9950421.tgfilter(c)
	return c:IsAbleToGrave()
end
function c9950421.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950421.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c9950421.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9950421.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c9950421.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end
	local ct={}
	for i=4,1,-1 do
		if Duel.IsPlayerCanDiscardDeckAsCost(tp,i) then
			table.insert(ct,i)
		end
	end
	if #ct==1 then 
		Duel.DiscardDeck(tp,ct[1],REASON_COST)
		e:SetLabel(1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9950421,0))
		local ac=Duel.AnnounceNumber(tp,table.unpack(ct))
		Duel.DiscardDeck(tp,ac,REASON_COST)
		e:SetLabel(ac)
	end
end
function c9950421.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local ct=e:GetLabel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		e1:SetValue(ct*500)
		c:RegisterEffect(e1)
	end
end