--魔力联合 黄槐决明
function c33200435.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCountLimit(1,33200435+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c33200435.spcon)
	e1:SetOperation(c33200435.spop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200435,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c33200435.cost)
	e2:SetTarget(c33200435.tg)
	e2:SetOperation(c33200435.op)
	c:RegisterEffect(e2)
end

--e1
function c33200435.spfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function c33200435.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
		and Duel.IsExistingMatchingCard(c33200435.spfilter,tp,0,LOCATION_GRAVE,1,nil)
end
function c33200435.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c33200435.spfilter,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

--e2
function c33200435.costfilter(c)
	return c:IsSetCard(0x329) and c:IsDiscardable()
end
function c33200435.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200435.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c33200435.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c33200435.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
end
function c33200435.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33200435,2))
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		Duel.MoveSequence(tc,1)
	end
	Duel.SortDecktop(tp,tp,2)
	if Duel.IsExistingMatchingCard(c33200435.mfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(33200435,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local smg=Duel.SelectMatchingCard(tp,c33200435.mfilter,tp,LOCATION_HAND,0,1,1,nil)
		if smg:GetCount()>0 then
			Duel.Summon(tp,smg:GetFirst(),true,nil)
		end
	end
end
function c33200435.mfilter(c)
	return c:IsSetCard(0x329) and c:IsSummonable(true,nil)
end