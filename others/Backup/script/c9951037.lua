--炎之巨人·苏鲁特
function c9951037.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMixRep(c,true,true,c9951037.ffilter,1,1,c9951037.ffilter1,c9951037.ffilter2,c9951037.ffilter3)
	--spsummon condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.fuslimit)
	c:RegisterEffect(e3)
	 --remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9951037,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c9951037.rmcon)
	e4:SetTarget(c9951037.rmtg)
	e4:SetOperation(c9951037.rmop)
	c:RegisterEffect(e4)
--atk/def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(c9951037.atkvalue)
	c:RegisterEffect(e4)
	 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951037.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951037.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951037,0))
end
function c9951037.ffilter(c,fc)
	return c:IsFusionSetCard(0xba5)
end
function c9951037.ffilter1(c,fc)
	return c:IsFusionType(TYPE_LINK) and c:IsFusionSetCard(0xba5)
end
function c9951037.ffilter2(c,fc)
	return c:IsFusionType(TYPE_XYZ) and c:IsFusionSetCard(0xba5)
end
function c9951037.ffilter3(c,fc)
	return c:IsFusionType(TYPE_SYNCHRO) and c:IsFusionSetCard(0xba5)
end
function c9951037.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c9951037.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c9951037.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,aux.ExceptThisCard(e))
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c9951037.rmfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c9951037.atkvalue(e,c)
	return Duel.GetMatchingGroupCount(c9951037.rmfilter,c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,nil)*1000
end
