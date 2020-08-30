--企鹅战法·思维扩充
function c79029281.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c79029281.target)
	e1:SetOperation(c79029281.activate)
	c:RegisterEffect(e1)  
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c79029281.sptg)
	e2:SetOperation(c79029281.spop)
	c:RegisterEffect(e2)	
end
function c79029281.filter(c)
	return c:IsType(TYPE_FUSION)
end
function c79029281.filter2(c)
	return c:IsSetCard(0xc90e) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c79029281.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029281.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c79029281.filter2,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c79029281.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetTargetCard(g)
end
function c79029281.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.SelectMatchingCard(tp,c79029281.filter2,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	local mg=tc:GetMaterial()
	local sg=Group.FromCards(g,e:GetHandler())
	Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_FUSION+REASON_EFFECT)
	sg:Merge(mg)
	tc:SetMaterial(sg)
	Debug.Message("博士，您还有许多事情需要处理。现在还不能休息哦。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029281,0))
end
function c79029281.mtfil(c,e,tp)
	return c:GetMaterial():IsContains(e:GetHandler()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_FUSION) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c79029281.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return eg:IsExists(c79029281.mtfil,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c79029281.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c79029281.mtfil,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	Debug.Message("博士，辛苦了！累了的话请休息一会儿吧。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029281,1))
end
