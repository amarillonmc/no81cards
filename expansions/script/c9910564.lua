--甜心机仆 枝桠的礼物
dofile("expansions/script/c9910550.lua")
function c9910564.initial_effect(c)
	--special summon
	QutryTxjp.AddSpProcedure(c,9910564)
	--flag
	QutryTxjp.AddTgFlag(c)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c9910564.spcon)
	e2:SetCost(c9910564.spcost)
	e2:SetTarget(c9910564.sptg)
	e2:SetOperation(c9910564.spop)
	c:RegisterEffect(e2)
end
function c9910564.spcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_MONSTER) and (LOCATION_HAND+LOCATION_GRAVE)&loc~=0
end
function c9910564.costfilter(c)
	return c:IsSetCard(0x3951) and c:IsDiscardable()
end
function c9910564.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() and Duel.IsExistingMatchingCard(c9910564.costfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c9910564.costfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c9910564.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	local p=rc:GetControler()
	if chk==0 then return rc:IsRelateToEffect(re) and Duel.GetLocationCount(p,LOCATION_MZONE,tp)>0
		and rc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE,p) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,rc,1,0,0)
end
function c9910564.drfilter(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c9910564.spop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsRelateToEffect(re) then return end
	if aux.NecroValleyNegateCheck(rc) then return end
	if Duel.SpecialSummon(rc,0,tp,rc:GetControler(),false,false,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==0 then return end
	Duel.ConfirmCards(1-tp,rc)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c9910564.drfilter,tp,0,LOCATION_MZONE,nil)
	if #g1>0 and #g2>0 and Duel.IsPlayerCanDraw(tp,g2:GetClassCount(Card.GetCode))
		and Duel.SelectYesNo(tp,aux.Stringid(9910564,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g1:Select(tp,1,1,nil)
		if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)==0 then return end
		g2=Duel.GetMatchingGroup(c9910564.drfilter,tp,0,LOCATION_MZONE,nil)
		local ct=g2:GetClassCount(Card.GetCode)
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end
