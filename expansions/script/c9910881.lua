--共生试验体 机筋铁卫
function c9910881.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c9910881.ffilter,2,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c9910881.splimit)
	c:RegisterEffect(e0)
	--atk & def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9910881.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c9910881.spcon)
	e3:SetTarget(c9910881.sptg)
	e3:SetOperation(c9910881.spop)
	c:RegisterEffect(e3)
end
function c9910881.ffilter(c,fc,sub,mg,sg)
	return not sg or sg:FilterCount(aux.TRUE,c)==0 or not sg:IsExists(Card.IsRace,1,c,c:GetRace())
end
function c9910881.splimit(e,se,sp,st)
	return st&SUMMON_TYPE_FUSION~=SUMMON_TYPE_FUSION or (se and se:GetHandler():IsCode(9910871))
end
function c9910881.atkfilter(c)
	return c:IsFaceup() and c:GetRace()~=0
end
function c9910881.atkval(e,c)
	local g=Duel.GetMatchingGroup(c9910881.atkfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=g:GetClassCount(Card.GetRace)
	return ct*100
end
function c9910881.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c9910881.spfilter(c,e,tp)
	return aux.IsCodeListed(c,9910871) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910881.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910881.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910881,0))
end
function c9910881.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910881.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
