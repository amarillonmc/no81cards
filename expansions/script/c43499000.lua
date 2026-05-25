--倒悬之树-守护他人的决意
local m=43499000
local cm=_G["c"..m]

function cm.initial_effect(c)
	--超量召唤手续
	aux.AddXyzProcedure(c,nil,10,3)
	c:EnableReviveLimit()
	
	--①：对方怪兽不能选择其他怪兽作为攻击对象
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(cm.atktarget)
	c:RegisterEffect(e1)
	
	--①：对方不能把场上的其他卡作为效果的对象
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(cm.efftarget)
	e2:SetValue(cm.effvalue)
	c:RegisterEffect(e2)
	
	--①：自己的怪兽不会被战斗破坏
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	
	--②：破坏怪兽提升攻击力
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.atkcon)
	e4:SetTarget(cm.atktg)
	e4:SetOperation(cm.atkop)
	c:RegisterEffect(e4)
end

--禁止攻击非此卡的怪兽
function cm.atktarget(e,c)
	return c~=e:GetHandler()
end

--禁止取非此卡的卡为效果对象
function cm.efftarget(e,c)
	return c~=e:GetHandler()
end
function cm.effvalue(e,re,rp)
	return rp==1-e:GetHandlerPlayer()
end

--发动条件：场上没有自身以外的「倒悬之树」(0xfb1)怪兽
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfb1) and not c:IsCode(m)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

--过滤：同名卡以外的己方怪兽
function cm.desfilter(c)
	return not c:IsCode(m)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	--选择自己场上的任意数量怪兽
	local g=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_MZONE,0,1,99,nil)
	if g:GetCount()>0 then
		local ct=Duel.Destroy(g,REASON_EFFECT)
		--破坏成功后提升攻击力
		if ct>0 and c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ct*500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
	end
end