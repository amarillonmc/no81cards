--陈·赤龙绝影
function c29065583.initial_effect(c)
	aux.AddCodeList(c,29065582)
	c:EnableCounterPermit(0x87ae)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x87af),8,2)
	c:EnableReviveLimit()
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAIABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c29065583.lvtg)
	e1:SetValue(c29065583.lvval)
	c:RegisterEffect(e1)
	--code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetValue(29065582)
	c:RegisterEffect(e2)	 
	--extra attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetCondition(c29065583.eatcon)
	e3:SetValue(1)
	c:RegisterEffect(e3) 
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c29065583.discon)
	e4:SetOperation(c29065583.disop)
	c:RegisterEffect(e4)
	--disable
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)	
	e6:SetType(EFFECT_TYPE_QUICK_O)  
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetRange(LOCATION_MZONE)  
	e6:SetCode(EVENT_CHAINING) 
	e6:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e6:SetTarget(c29065583.target) 
	e6:SetCondition(c29065583.condition)	
	e6:SetOperation(c29065583.activate) 
	e6:SetCountLimit(1)  
	c:RegisterEffect(e6)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetOperation(c29065583.lrop)
	c:RegisterEffect(e6)
end
function c29065583.lvtg(e,c)
	return c:IsLevelAbove(1) and c:GetCounter(0x87ae)>0 and c:IsSetCard(0x87af)
end
function c29065583.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return 8
	else return lv end
end
function c29065583.eatcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c29065583.discon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or not g:IsExists(Card.IsSetCard,1,nil,0x87af) then return false end
	return re:GetHandler():GetControler()~=tp and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,29065582)
end
function c29065583.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c29065583.ckfil(c)
	return c:IsSetCard(0x87af) and not c:IsCode(29065583)
end
function c29065583.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return Duel.IsChainNegatable(ev) and rc:GetControler()~=tp and  Duel.IsExistingMatchingCard(c29065583.ckfil,tp,LOCATION_MZONE,0,1,e:GetHandler()) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,29065582)
end
function c29065583.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
	e:GetHandler():RegisterFlagEffect(29065583,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(29065583,0))
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end 
function c29065583.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
	Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c29065583.lrop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) then return false end
	Debug.Message("斩龙之剑，鞘中赤红；剑锋破矢，赤龙绝影！")
	Debug.Message("XYZ召唤！RANK 8！陈•赤龙绝影！")
end