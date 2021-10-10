--阿蒙的主谋者
local m=40009826
local cm=_G["c"..m]
cm.named_with_Amon=1
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--pendulum summon
	aux.EnablePendulumAttribute(c) 
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)   
	--summon with s/t
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetTarget(function(e,c) return e:GetHandler()~=c and c:IsLocation(LOCATION_PZONE) and c:IsType(TYPE_PENDULUM) end)
	e1:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e1)  
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--sp token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.tkcon)
	e3:SetTarget(cm.tktg)
	e3:SetOperation(cm.tkop)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.discon)
	e4:SetCost(cm.discost)
	e4:SetTarget(cm.distg)
	e4:SetOperation(cm.disop)
	c:RegisterEffect(e4)
	--decrease tribute
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DECREASE_TRIBUTE)
	e6:SetRange(LOCATION_PZONE)
	e6:SetTargetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_SZONE+LOCATION_EXTRA+LOCATION_OVERLAY+LOCATION_PZONE,0)
	e6:SetCountLimit(1,m)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_PENDULUM))
	e6:SetValue(0x1)
	c:RegisterEffect(e6) 
end
function cm.spfilter(c,e,tp)
	return c:IsCode(40009828) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function cm.cfilter(c,tp)
	return c:IsControler(tp)
end
function cm.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,1-tp) and Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_EXTRA,0,5,nil)
end
function cm.ctfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=4 then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local sg=g:Filter(Card.IsType,nil,TYPE_PENDULUM)
	if sg:GetCount()>0 then
		Duel.DisableShuffleCheck()
		Duel.SendtoExtraP(sg,tp,REASON_EFFECT)
		g:Sub(sg)
	end
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER))
		and re:GetHandler()~=e:GetHandler() and Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_EXTRA,0,10,nil)
end
function cm.costfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeckAsCost()
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_EXTRA,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_EXTRA,0,3,3,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end


