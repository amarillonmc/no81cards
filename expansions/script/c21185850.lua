--秋姬 蒹葭秋水
function c21185850.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c21185850.tg)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,21185850)
	e2:SetTarget(c21185850.tg2)
	e2:SetOperation(c21185850.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,21185851)
	e3:SetCondition(c21185850.con3)
	e3:SetTarget(c21185850.tg3)
	e3:SetOperation(c21185850.op3)
	c:RegisterEffect(e3)
end
function c21185850.tg(e,c)
	return c:GetMutualLinkedGroupCount()>0
end
function c21185850.w(c,e)
	return c:GetSequence()<5 and c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function c21185850.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c21185850.w,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then return #g>=2 and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(3,tp,HINTMSG_OPERATECARD)
	local sg=g:Select(tp,2,2,nil)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c21185850.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Draw(tp,1,REASON_EFFECT)>0 and #g>=2 then
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	Duel.SwapSequence(tc1,tc2)
	end
end
function c21185850.q(c)
	return c:IsFaceup() and c:IsCode(21185845) and c:GetSequence()==2
end
function c21185850.con3(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and Duel.IsExistingMatchingCard(c21185850.q,tp,4,0,1,nil)
end
function c21185850.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,4)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_GRAVE)
end
function c21185850.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end