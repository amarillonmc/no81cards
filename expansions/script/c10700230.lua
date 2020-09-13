--破晓连结 怜
function c10700230.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c10700230.lcheck)
	c:EnableReviveLimit() 
	--link
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e0:SetCondition(c10700230.lkcon)  
	e0:SetOperation(c10700230.lkop)  
	c:RegisterEffect(e0)	 
	--atk,def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(c10700230.atkval)
	c:RegisterEffect(e1)  
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c10700230.thcon)
	e2:SetCondition(c10700230.actcon)
	c:RegisterEffect(e2)
	--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10700221,1))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,10700230)
	e4:SetTarget(c10700230.tgtg)
	e4:SetOperation(c10700230.tgop)
	c:RegisterEffect(e4)
end
function c10700230.lcheck(g,lc)
	return g:IsExists(c10700230.mzfilter,1,nil)
end
function c10700230.mzfilter(c)
	return c:IsLinkSetCard(0x3a01) and not c:IsLinkType(TYPE_LINK)
end
function c10700230.lkcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)  
end  
function c10700230.lkop(e,tp,eg,ep,ev,re,r,rp)  
	Debug.Message("今天是适合修行的好日子")
	Debug.Message("有你在身边的话，似乎就能一起变强。今后请多指教")
end
function c10700230.atkval(e,c)
	return c:GetLinkedGroupCount()*200
end
function c10700230.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3a01) and c:IsType(TYPE_LINK) and c:IsControler(tp)
end
function c10700230.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetMutualLinkedGroupCount()>0
end
function c10700230.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and c10700230.cfilter(a,tp)) or (d and c10700230.cfilter(d,tp))
end
function c10700230.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x3a01) or c:IsType(TYPE_DUAL)) and c:IsAbleToGrave()
end
function c10700230.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700230.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c10700230.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10700230.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end