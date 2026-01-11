--无名的肃清
local s,id,o=GetID()
function s.initial_effect(c)
	--①：取对象炸纵列 + 自选封格子
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	--手卡发动许可
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
end

-- 手卡发动条件：对方场上怪兽攻击力合计 >= 4000
function s.handcon(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	return g:GetSum(Card.GetAttack)>=4000
end

-- Target：场上1只表侧表示怪兽
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	
	-- 设置Info：获取该怪兽当前纵列的所有卡
	local tc=g:GetFirst()
	local cg=tc:GetColumnGroup()
	cg:AddCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,cg,#cg,0,0)
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
	   e:SetLabel(100)
	end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end

	-- 1. 送去墓地
	local g=tc:GetColumnGroup()
	g:AddCard(tc)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	if e:GetLabel()==100 then
	local groundcollapse=true
		if groundcollapse and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.BreakEffect()
		local zone=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		if tp==1 then
			zone=((zone&0xffff)<<16)|((zone>>16)&0xffff)
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetValue(zone)
		Duel.RegisterEffect(e1,tp)
		end
	end
end