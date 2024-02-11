--私欲之壶
function c98920729.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98920729+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c98920729.target)
	e1:SetOperation(c98920729.activate)
	c:RegisterEffect(e1)
end
function c98920729.thfilter(c)
	return c:IsSetCard(0x2e) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c98920729.filter(c)
	return c:IsSetCard(0x2e) and c:IsSummonable(true,nil)
end
function c98920729.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,3,nil)
	local b2=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,2,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(98920729,0),aux.Stringid(98920729,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(98920729,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(98920729,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
	end
end
function c98920729.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	if e:GetLabel()==0 then
		Duel.Draw(tp,math.floor(ct1/3),REASON_EFFECT)
	else
		Duel.Draw(tp,math.floor(ct2/2),REASON_EFFECT)
	end
end