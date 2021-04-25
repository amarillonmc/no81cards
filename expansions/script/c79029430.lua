--嘉维尔·时代收藏-战医
function c79029430.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c79029430.matfilter,5,2,c79029430.ovfilter,aux.Stringid(79029430,0))
	c:EnableReviveLimit()
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79029109)
	c:RegisterEffect(e2)
	--duel status
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_DUAL))
	e1:SetCode(EFFECT_DUAL_STATUS)
	c:RegisterEffect(e1)
	--change lp 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c79029430.cltg)
	e3:SetOperation(c79029430.clop)
	c:RegisterEffect(e3)  
	--disable spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_SUMMON)
	e6:SetCondition(c79029430.dscon)
	e6:SetCost(c79029430.dscost)
	e6:SetTarget(c79029430.dstg)
	e6:SetOperation(c79029430.dsop)
	c:RegisterEffect(e6)
	local e8=e6:Clone()
	e8:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e8) 
end
function c79029430.ovfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_DUAL)
end
function c79029430.cltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end  
end
function c79029430.clop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp and Duel.SelectYesNo(tp,aux.Stringid(79029430,1)) then
	Debug.Message("振作起来啊！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029430,3))
	Duel.SetLP(tp,4000)
	else
	Debug.Message("现在就来救你！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029430,2))
	Duel.SetLP(tp,2000)
	end
end
function c79029430.dscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029430.dixfil(c)
	return c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_DUAL)
end
function c79029430.dscon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0 and e:GetHandler():GetOverlayGroup():IsExists(c79029430.dixfil,1,nil)
end
function c79029430.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c79029430.dsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	Debug.Message("干什么呢你！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029430,4))
end










