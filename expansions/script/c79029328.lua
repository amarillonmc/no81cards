--艾雅法拉·瑟谣浮收藏-灵焰月
function c79029328.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c79029328.mfilter,c79029328.xyzcheck,3,3)
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79029035)
	c:RegisterEffect(e2)	
	--ov
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,79029328)
	e1:SetCondition(c79029328.descon)
	e1:SetOperation(c79029328.op)
	c:RegisterEffect(e1)   
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c79029328.atkval)
	c:RegisterEffect(e1) 
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3) 
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetCondition(c79029328.actcon)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029328,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1)
	e1:SetCost(c79029328.cost)
	e1:SetTarget(c79029328.target)
	e1:SetOperation(c79029328.activate)
	c:RegisterEffect(e1) 
end
function c79029328.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_LINK) and c:IsLinkAbove(3)
end
function c79029328.xyzcheck(g)
	return g:GetClassCount(Card.GetLinkMarker)==1
end
function c79029328.fil(c,e,tp)
	return c:IsType(TYPE_LINK) and c:IsCanOverlay() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=c:GetLink() and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=c:GetLink()
end
function c79029328.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and Duel.IsExistingMatchingCard(c79029328.fil,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) 
end
function c79029328.op(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("可能有点热哦？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029328,1))
	local tc=Duel.SelectMatchingCard(tp,c79029328.fil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,99,nil,e,tp):GetFirst()
	Duel.Overlay(e:GetHandler(),tc)
	local mg1=Duel.GetDecktopGroup(tp,tc:GetLink())
	local mg2=Duel.GetDecktopGroup(1-tp,tc:GetLink())
	mg1:Merge(mg2)
	Duel.Overlay(e:GetHandler(),mg1)
	Duel.Damage(1-tp,mg1:GetCount()*500,REASON_EFFECT)
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_RANK)
	e1:SetValue(tc:GetLink())
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
end
function c79029328.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function c79029328.actcon(e)
	local tp=e:GetHandler():GetControler()
	return Duel.GetTurnPlayer()==tp
end
function c79029328.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029328.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	Duel.SetTargetCard(sg)
end
function c79029328.activate(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("加油！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029328,2))
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029328,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	e1:SetValue(c79029328.efilter)
	tc:RegisterEffect(e1)
end
function c79029328.efilter(e,te)
	return te:GetOwner():GetControler()~=e:GetOwner():GetControler()
end





