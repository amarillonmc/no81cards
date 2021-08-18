--龙门·特种干员-阿消
function c79029040.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c79029040.spcon)
	e1:SetOperation(c79029040.spop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,79029040)
	e2:SetTarget(c79029040.sptg)
	e2:SetOperation(c79029040.spop)
	c:RegisterEffect(e2)
end
function c79029040.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return false end
	local tg=g:GetMaxGroup(Card.GetAttack)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and tg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c79029040.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Debug.Message("出——发——！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029140,1))
end
function c79029040.tdfilter2(c)
	return c:IsAbleToHand()
end
function c79029040.tdcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1099,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1099,2,REASON_COST)
end
function c79029040.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79029040.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Debug.Message("准备就绪。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029040,2))
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
	if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(79029040,3)) then 
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Debug.Message("走开走开！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029040,0))
	end
	end
end



