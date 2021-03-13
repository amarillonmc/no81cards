local m=15000475
local cm=_G["c"..m]
cm.name="星拟虚像·超弦理论之爱子"
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	c:EnableReviveLimit()
	--avoid atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetCondition(cm.atcon)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetCondition(cm.atcon)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--disable when chain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
	--SSet
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,m)
	e4:SetCost(cm.cost)
	e4:SetCondition(cm.setcon)
	e4:SetOperation(cm.setop)
	c:RegisterEffect(e4)
end
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xf34)
end
function cm.cfilter(c,code)
	return c:IsFaceup() and (c:IsSetCard(0xf34) or c:IsSetCard(0x41)) and not c:IsCode(code)
end
function cm.atcon(e)
	return Duel.IsExistingMatchingCard(cm.cfilter,e:GetOwnerPlayer(),LOCATION_MZONE,0,1,nil,e:GetHandler():GetCode())
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	tc:RegisterFlagEffect(m,RESET_CHAIN,0,1)
	--disable when chain
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(cm.disable)
	e1:SetReset(RESET_CHAIN)
	e:GetHandler():RegisterEffect(e1)
end
function cm.disable(e,c)
	return c:GetFlagEffect(m)==0 and not c:IsCode(m)
end
function cm.costfilter(c)
	return c:IsSetCard(0x41) and c:IsAbleToDeckAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cm.setfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		if tc:IsSetCard(0xf34) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end