--罗德岛·近卫干员-杜宾
function c79029144.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_MONSTER),aux.NonTuner(Card.IsSynchroType,TYPE_NORMAL),1)
	c:EnableReviveLimit()   
	--R
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE+LOCATION_HAND,0)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetTarget(c79029144.tg)
	e1:SetValue(0x1901)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,79029144)
	e2:SetCost(c79029144.cost)
	e2:SetTarget(c79029144.target)
	e2:SetOperation(c79029144.activate)
	e2:SetLabel(0)
	c:RegisterEffect(e2)
	--atk def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTarget(c79029144.tg1)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
end
function c79029144.tg(e,c)
	return c:IsSetCard(0xa900)
end
function c79029144.tg1(e,c)
	return c:IsSetCard(0xa900) and c:IsLevelBelow(4)
end
function c79029144.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c79029144.costfilter(c,e,tp)
	return c:IsFaceup() and c:GetOriginalLevel()>0 and Duel.IsExistingMatchingCard(c79029144.spfilter,tp,LOCATION_DECK,0,1,nil,c,e,tp) and c:IsSetCard(0xa900)
		and Duel.GetMZoneCount(tp,c)>0
end
function c79029144.spfilter(c,tc,e,tp)
	return c:GetLevel()<tc:GetLevel() and c:IsSetCard(0xa900)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79029144.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c79029144.costfilter,1,nil,e,tp)
	end
	e:SetLabel(0)
	local g=Duel.SelectReleaseGroup(tp,c79029144.costfilter,1,1,nil,e,tp)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c79029144.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79029144.spfilter,tp,LOCATION_DECK,0,1,1,nil,tc,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
