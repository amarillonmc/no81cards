--掌 握 体 验 派 的 女 演 员
local m=43990019
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,43990016)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,43990019)
	e1:SetCost(c43990019.drcost)
	e1:SetTarget(c43990019.drtg)
	e1:SetOperation(c43990019.drop)
	c:RegisterEffect(e1)
	--can't be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c43990019.condition)
	e2:SetTarget(c43990019.tglimit)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c43990019.condition)
	e3:SetValue(c43990019.atlimit)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,43991019)
	e4:SetCondition(c43990019.spcon)
	e4:SetTarget(c43990019.sptg)
	e4:SetOperation(c43990019.spop)
	c:RegisterEffect(e4)
	
end
function c43990019.atlimit(e,c)
	return not c:IsCode(43990016)
end
function c43990019.tglimit(e,c)
	return not c:IsCode(43990016)
end
function c43990019.spcfilter(c)
	return c:IsFaceup() and c:IsCode(43990017)
end
function c43990019.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c43990019.spcfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c43990019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c43990019.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c43990019.cfilter(c)
	return c:IsFaceup() and c:IsCode(43990016)
end
function c43990019.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c43990019.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c43990019.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,c)
	if chk==0 then return c:IsAbleToGrave() and b2 end
	if b2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,1,c)
		local gc=g:GetFirst()
		e:SetLabel(gc:GetCode())
		g:AddCard(c)
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function c43990019.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCode(43990016) and c:IsAbleToGrave()
end
function c43990019.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990019.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c43990019.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c43990019.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(43990019,0)) then
		Duel.BreakEffect()
		if Duel.Draw(tp,1,REASON_EFFECT)~=0 and e:GetLabel()==43990016 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(43990019,0)) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end







