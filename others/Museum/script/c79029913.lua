--罗德岛·狙击干员-假日威龙陈
function c79029913.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	aux.AddFusionProcCodeFunRep(c,79029025,c79029913.mafilter,2,99,true,true)
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)	
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,79029913)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c79029913.discon)
	e3:SetCost(c79029913.discost)
	e3:SetTarget(c79029913.distg)
	e3:SetOperation(c79029913.disop)
	c:RegisterEffect(e3)  
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e4:SetRange(LOCATION_MZONE) 
	e4:SetCountLimit(1,09029913)
	e4:SetCost(c79029913.xxcost)
	e4:SetTarget(c79029913.xxtg)
	e4:SetOperation(c79029913.xxop)
	c:RegisterEffect(e4)
end
function c79029913.mafilter(c)
	return c:IsSetCard(0xa900) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c79029913.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c79029913.ckfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa900) and c:IsCanOverlay() 
end
function c79029913.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c79029913.ckfil,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c79029913.ckfil,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.Overlay(c,g)
end
function c79029913.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c79029913.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
	Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	local x=e:GetHandler():GetMaterialCount()
	Duel.Damage(1-tp,x*500,REASON_EFFECT)
	Debug.Message("这里交给我。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029913,1))
	end
end
function c79029913.xxcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029913.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c79029913.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c79029913.chcon)
	e1:SetOperation(c79029913.chop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Debug.Message("都准备好了吗？那么，走。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029913,2))
end
function c79029913.chcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c79029913.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if x>0 and Duel.CheckLPCost(1-tp,x*800) and Duel.SelectYesNo(1-tp,aux.Stringid(79029913,0)) then 
	Duel.PayLPCost(1-tp,x*800)
	Debug.Message("哼！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029913,3))
	else
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	if g:GetCount()<=0 then return end
	Debug.Message("留下他们。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029913,4))
	local rg=g:RandomSelect(tp,1)
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end




