--千夜 瞬间爆炸
function c60150604.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c60150604.condition)
	e1:SetTarget(c60150604.target)
	e1:SetOperation(c60150604.activate)
	c:RegisterEffect(e1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c60150604.spcon)
	c:RegisterEffect(e1)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_TO_DECK)
	e4:SetCountLimit(1,60150604)
	e4:SetCondition(c60150604.descon)
	e4:SetTarget(c60150604.destg)
	e4:SetOperation(c60150604.desop)
	c:RegisterEffect(e4)
end
function c60150604.tfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetSummonPlayer()~=tp 
		and c:IsDestructable()
end
function c60150604.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x3b21) then return false end
	return tp~=ep and eg:GetCount()>=2
end
function c60150604.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c60150604.tfilter,nil,tp)
	if not e:GetHandler():IsDestructable() then return false end
	if g:GetCount()==0 then return
		false 
	else
		if chk==0 then return true end
		Duel.SetTargetCard(eg)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)  
	end
end
function c60150604.tfilter2(c,e,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetSummonPlayer()~=tp 
		and c:IsDestructable() and c:IsRelateToEffect(e) 
end
function c60150604.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(c60150604.tfilter2,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.Destroy(g,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		end
	end
end
function c60150604.xyzlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x5b21)
end
function c60150604.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3b21)
end
function c60150604.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c60150604.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c60150604.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not (c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)) 
		and c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_EXTRA)
		and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c60150604.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c60150604.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150604.filter2,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c60150604.filter2,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60150604,1))
end
function c60150604.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c60150604.filter2,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end