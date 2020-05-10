--fate·超越X·Alter-解放形态
function c9950447.initial_effect(c)
	c:SetUniqueOnField(1,0,9950447)
	  --synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),aux.NonTuner(Card.IsSetCard,0xba5),1)
	c:EnableReviveLimit()
 --special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,9950447)
	e2:SetCondition(c9950447.spcon)
	e2:SetOperation(c9950447.spop)
	c:RegisterEffect(e2)
--anti summon and remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,99504470)
	e1:SetCondition(c9950447.rmcon)
	e1:SetTarget(c9950447.rmtg)
	e1:SetOperation(c9950447.rmop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950447.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950447.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950447,0))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9950447,1))
end
c9950447.spchecks=aux.CreateChecks(Card.IsCode,{9950446,9950445})
function c9950447.spcostfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
		and c:IsAbleToRemoveAsCost() and c:IsCode(9950446,9950445)
end
function c9950447.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c9950447.spcostfilter,tp,
	LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return g:CheckSubGroupEach(c9950447.spchecks,aux.mzctcheck,tp)
end
function c9950447.spop(e,tp,eg,ep,ev,re,r,rp,c)
	 local g=Duel.GetMatchingGroup(c9950447.spcostfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroupEach(tp,c9950447.spchecks,false,aux.mzctcheck,tp)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c9950447.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c9950447.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(aux.TRUE,nil,e:GetHandler())
	local g2=Duel.GetMatchingGroup(Card.IsSummonType,tp,0,LOCATION_MZONE,nil,SUMMON_TYPE_SPECIAL)
	g:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c9950447.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	local g=eg:Clone()
	local g2=Duel.GetMatchingGroup(Card.IsSummonType,tp,0,LOCATION_MZONE,g,SUMMON_TYPE_SPECIAL)
	g:Merge(g2)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
  Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950447,0))
  Duel.Hint(HINT_SOUND,0,aux.Stringid(9950447,2))
end