--地狱领主
function c98921101.initial_effect(c)
	--summon proc
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(98921101,0))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetCondition(c98921101.sumcon)
	e0:SetOperation(c98921101.sumop)
	e0:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e0)	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98921101,2))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,98921101)
	e1:SetTarget(c98921101.damtg)
	e1:SetOperation(c98921101.damop)
	c:RegisterEffect(e1)
end
function c98921101.refil(c)
	return c:IsReleasable() and c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c98921101.sumcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return   Duel.IsExistingMatchingCard(c98921101.refil,tp,LOCATION_DECK,0,1,nil)
end
function c98921101.sumop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c98921101.refil,tp,LOCATION_DECK,0,1,1,nil)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_RELEASE+REASON_SUMMON+REASON_MATERIAL)
end
function c98921101.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function c98921101.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c98921101.tdfilter,tp,LOCATION_GRAVE,0,nil)
	local ct=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	if ct>0 then
		Duel.Damage(1-tp,ct*200,REASON_EFFECT)
	end
end