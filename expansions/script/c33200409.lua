--夜幕魔术团 红心女王-龙骑
function c33200409.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33200409+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c33200409.spcon)
	e1:SetOperation(c33200409.spop)
	c:RegisterEffect(e1)	
	--immune spell
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c33200409.efilter)
	c:RegisterEffect(e2)  
	--atk twice
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--effect
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCountLimit(1,33200410)
	e4:SetCondition(c33200409.descon)
	e4:SetTarget(c33200409.destg)
	e4:SetOperation(c33200409.desop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end

--e1
function c33200409.spfilter(c)
	return c:IsSetCard(0x329) and c:IsAbleToRemoveAsCost()
end
function c33200409.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
		and Duel.IsExistingMatchingCard(c33200409.spfilter,tp,LOCATION_GRAVE,0,4,nil)
end
function c33200409.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c33200409.spfilter,tp,LOCATION_GRAVE,0,4,4,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

--e2
function c33200409.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL)
end

--e4
function c33200409.descon(e,c)
	return not Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,TYPE_SPELL)
end
function c33200409.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c33200409.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200409.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c33200409.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c33200409.climit)
end
function c33200409.desop(e,tp,eg,ep,ev,re,r,rp)
	local desg=Duel.GetMatchingGroup(c33200409.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(desg,REASON_EFFECT)
end
function c33200409.climit(e,lp,tp)
	return lp==tp or not e:IsHasType(EFFECT_TYPE_ACTIVATE)
end
