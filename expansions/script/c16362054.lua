--时空怪盗 混元天尊·荒神赋形
function c16362054.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xdc0),c16362054.matfilter,2,true)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,16362054)
	e1:SetTarget(c16362054.tgcon)
	e1:SetTarget(c16362054.tgtg)
	e1:SetOperation(c16362054.tgop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,16362154)
	e2:SetCondition(c16362054.discon)
	e2:SetTarget(c16362054.distg)
	e2:SetOperation(c16362054.disop)
	c:RegisterEffect(e2)
end
function c16362054.matfilter(c)
	return not c:IsFusionAttribute(ATTRIBUTE_LIGHT)
end
function c16362054.atkfilter(c)
	return c:IsFaceup() and c:IsAttackAbove(2000)
end
function c16362054.tgcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c16362054.atkfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c16362054.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mc=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if chk==0 then return Duel.IsExistingMatchingCard(c16362054.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_MZONE)
end
function c16362054.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAttackBelow(2000)
end
function c16362054.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c16362054.atkfilter,1-tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		if Duel.SendtoGrave(sg,REASON_RULE,1-tp)~=0 then
			local g=Duel.GetMatchingGroup(c16362054.spfilter,1-tp,LOCATION_GRAVE,0,nil,e,1-tp)
			if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
				and g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(16362054,1)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
				local sg=g:Select(1-tp,1,1,nil)
				Duel.SpecialSummon(sg,0,1-tp,1-tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c16362054.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c16362054.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c16362054.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end