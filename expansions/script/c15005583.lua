local m=15005583
local cm=_G["c"..m]
cm.name="捕食植物 舌叶奇美拉桑寄生"
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--apply
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.opcon)
	e3:SetTarget(cm.rptg)
	e3:SetOperation(cm.rpop)
	c:RegisterEffect(e3)
	--position
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_POSITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(cm.potg)
	e2:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e2)
	--setatk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(cm.potg)
	e1:SetValue(0)
	c:RegisterEffect(e1)
end
function cm.potg(e,c)
	return c:IsFaceup() and c:GetCounter(0x1041)>0
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function cm.opcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil)
end
function cm.rpfilter(c,e,tp)
	return c:IsSetCard(0x10f3) and c:IsType(TYPE_MONSTER) and ((c:IsType(TYPE_PENDULUM) and (c:IsFaceup() or c:IsLocation(LOCATION_DECK)) and not c:IsForbidden())
		or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function cm.rptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rpfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function cm.rpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local g=Duel.SelectMatchingCard(tp,cm.rpfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		local b1=(tc:IsType(TYPE_PENDULUM) and (tc:IsFaceup() or tc:IsLocation(LOCATION_DECK)) and not tc:IsForbidden())
		local b2=(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false))
		local op=0
		if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
		elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,1))
		else op=Duel.SelectOption(tp,aux.Stringid(m,2))+1 end
		if op==0 then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end