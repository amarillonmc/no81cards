--夏日连结 佩可莉姆
function c10700238.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,3,c10700238.lcheck) 
	--link
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e0:SetCondition(c10700238.lkcon)  
	e0:SetOperation(c10700238.lkop)  
	c:RegisterEffect(e0)  
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10700238,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10700238)
	e3:SetCondition(c10700238.rmcon)
	e3:SetTarget(c10700238.rmtg)
	e3:SetOperation(c10700238.rmop)
	c:RegisterEffect(e3) 
	--effect gain
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10700238,2))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c10700238.atktg)
	e4:SetOperation(c10700238.atkop)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c10700238.eftg)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5) 
end
function c10700238.lcheck(g,lc)
	return g:IsExists(c10700238.mzfilter,1,nil)
end
function c10700238.mzfilter(c)
	return c:IsLinkSetCard(0x3a01) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c10700238.lkcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)  
end  
function c10700238.lkop(e,tp,eg,ep,ev,re,r,rp)  
	Debug.Message("吃光这些海鲜吧~")
	Debug.Message("能来到海边，真的很开心！一同享受夏日吧！")
end
function c10700238.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3a01) and c:IsType(TYPE_NORMAL)
end
function c10700238.rmcon(e)
	local ac=Duel.GetAttacker()
	return ac and c10700238.cfilter(ac) and e:GetHandler():GetLinkedGroup():IsContains(ac)
end
function c10700238.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
	Debug.Message("变得湿漉漉吧~")
	Debug.Message("公主浪花飞溅！（Princess-splash）")
end
function c10700238.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	local opt=0
	if g1:GetCount()>0 and g2:GetCount()>0 then
		opt=Duel.SelectOption(tp,aux.Stringid(10700238,3),aux.Stringid(10700238,4))
	elseif g1:GetCount()>0 then
		opt=0
	elseif g2:GetCount()>0 then
		opt=1
	else
		return
	end
	local sg=nil
	if opt==0 then
		sg=g1:RandomSelect(tp,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		sg=g2:Select(tp,1,1,nil)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
function c10700238.eftg(e,c)
	local lg=e:GetHandler():GetLinkedGroup()
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x3a01) and lg:IsContains(c)
end
function c10700238.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3a01)
end
function c10700238.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700238.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c10700238.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c10700238.atkfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(300)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end