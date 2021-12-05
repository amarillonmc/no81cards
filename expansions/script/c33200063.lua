--铁战灵兽 巨金怪
function c33200063.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33200063+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c33200063.spcon)
	e1:SetOperation(c33200063.spop)
	c:RegisterEffect(e1)  
	--send to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200063,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,33210063)
	e2:SetTarget(c33200063.target)
	e2:SetOperation(c33200063.operation)
	c:RegisterEffect(e2)   
	--cannot be Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c33200063.destg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end

--e1
function c33200063.spfilter(c,ft)
	return c:IsFaceup() and (c:IsSetCard(0x322) or c:IsSetCard(0x324)) and not c:IsCode(33200063) and c:IsAbleToDeckAsCost()
		and (ft>0 or c:GetSequence()<5)
end
function c33200063.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c33200063.spfilter,tp,LOCATION_MZONE,0,1,nil,ft)
end
function c33200063.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c33200063.spfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end

--e2
function c33200063.tgfilter(c)
	return (c:IsSetCard(0x322) or c:IsSetCard(0x324)) and c:IsAbleToGrave()
end
function c33200063.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200063.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c33200063.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c33200063.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

--e3
function c33200063.destg(e,c)
	return (c:IsSetCard(0x322) or c:IsSetCard(0x324))
end