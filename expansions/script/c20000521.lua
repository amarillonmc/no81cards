--万蔑邪魔凰
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,20000516,cm.fuf,1,true,true)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(cm.con3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetTarget(cm.tg5)
	e5:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e5)
end
--fu
function cm.fuf(c,fc,sub,mg,sg)
	return c:IsRace(RACE_FIEND)
end
--e1
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
--e3
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsRace,1,nil,RACE_FIEND)
end
function cm.opf3(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0x3fd5,0xfd6)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.opf3,tp,LOCATION_GRAVE,0,e:GetHandler())
	if Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0 and #g>3 
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_CARD,0,m)
		g = g:Select(tp,4,4,e:GetHandler())
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
--e5
function cm.tg5(e,c)
	return c:IsAttackPos()
end