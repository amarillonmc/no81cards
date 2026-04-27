--龙牢具现：灰烬灼铠
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1)  
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.atktg)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--banish and negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.condition)
	e3:SetTarget(s.target)
	e3:SetOperation(s.activate)
	c:RegisterEffect(e3)
	--set
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_REMOVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,id+o*100)
	e5:SetCost(s.setcost)
	e5:SetTarget(s.settg)
	e5:SetOperation(s.setop)
	c:RegisterEffect(e5)
end
function s.atktg(e,c)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_DRAGON)
end
function s.tfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
		and c:IsType(TYPE_XYZ) and c:IsRace(RACE_DRAGON) and c:IsControler(tp)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainDisablable(ev) then return false end
	local ct=Duel.GetCurrentChain()
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local te,p=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local b1=re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and tg and tg:IsExists(s.tfilter,1,nil,tp) and #tg==1
	local b2=ct>=2 and te and te:GetHandler():IsSetCard(0x725a) and p==tp
	return rp==1-tp and (b1 or b2)
end
function s.cfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToRemove()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.cfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.cfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)
		and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then
		Duel.NegateEffect(ev)
	end
end
function s.setfilter(c)
	return c:IsSetCard(0x725a) and not c:IsPublic()
end
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_HAND,0,1,1,nil)
	local sc=g:GetFirst()
	Duel.ConfirmCards(1-tp,sc)
	Duel.ShuffleHand(tp)
	sc:CreateEffectRelation(e)
	e:SetLabelObject(sc)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and not c:IsForbidden() and c:CheckUniqueOnField(tp) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end
