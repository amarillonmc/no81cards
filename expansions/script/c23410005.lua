--蜃境
local cm,m,o=GetID()
function cm.initial_effect(c)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_COIN)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(cm.discon)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
end
function cm.hfil(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and not c:IsForbidden()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.hfil,tp,LOCATION_HAND,0,1,nil)
		and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>1 and not e:GetHandler():IsForbidden() end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(1-tp,LOCATION_SZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.hfil,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 and Duel.MoveToField(c,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetRange(0xff)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetRange(0xff)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(TYPE_SPELL)
		c:RegisterEffect(e1)
		Duel.MoveToField(g:GetFirst(),tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and Duel.IsChainNegatable(ev)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.TossCoin(tp,1)==1 then Duel.NegateActivation(ev) end
end