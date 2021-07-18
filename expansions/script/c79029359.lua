--罗德岛·近卫干员-阿米娅
function c79029359.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,3,99,c79029359.lcheck)
	c:EnableReviveLimit() 
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.linklimit)
	c:RegisterEffect(e1)   
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c79029359.val)
	c:RegisterEffect(e2)   
	--atk down
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,79029359)
	e1:SetCost(c79029359.tgcost)  
	e1:SetTarget(c79029359.tgtg)
	e1:SetOperation(c79029359.tgop)
	c:RegisterEffect(e1)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,09029359)
	e3:SetCondition(c79029359.negcon)
	e3:SetOperation(c79029359.negop)
	c:RegisterEffect(e3)	
end
function c79029359.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xa900)
end
function c79029359.val(e,c)
	local g=Duel.GetMatchingGroup(nil,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local ct=g:GetCount()
	return ct*500
end
function c79029359.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c79029359.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c79029359.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c79029359.tdfil(c)
	return c:IsSetCard(0xa900) and c:IsAbleToDeck()
end
function c79029359.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029359.tdfil,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil) and mg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_REMOVED+LOCATION_GRAVE)
	Debug.Message("我背负着许多人的愤怒。")
	Duel.Hint(HINT_SOUND,tp,aux.Stringid(79029359,0))
end
function c79029359.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c79029359.tdfil,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil)
	if g:GetCount()<=0 then return false end
	local xg=g:Select(tp,1,99,nil)
	local x=Duel.SendtoDeck(xg,nil,2,REASON_EFFECT)
	local mg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if mg:GetCount()<=0 then return false end 
	local tc=mg:GetFirst() 
	while tc do
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(x*-1000)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	tc=mg:GetNext()
	end  
	local sg=Duel.GetMatchingGroup(Card.IsAttack,tp,0,LOCATION_MZONE,nil,0)
	local a=Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RULE)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-a*800)
end
function c79029359.negcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) 
end
function c79029359.negop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("这把剑渴望着报复......我不能放纵它。")
	Duel.Hint(HINT_SOUND,tp,aux.Stringid(79029359,1))
	local c=e:GetHandler()
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetOperation(c79029359.negop1)
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e3,tp) 
end
function c79029359.negop1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:GetControler()~=tp and Duel.SelectEffectYesNo(tp,e:GetHandler()) then
	Debug.Message("你的想法，你的法术，我都能切开。")
	Duel.Hint(HINT_SOUND,tp,aux.Stringid(79029359,2))
	Duel.Hint(HINT_CARD,0,79029359)
	Duel.NegateEffect(ev)
	Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
	e:Reset()
	end
end








