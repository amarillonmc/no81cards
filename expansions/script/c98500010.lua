function c98500010.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,6007213,c98500010.ffilter,1,true,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToDeckOrExtraAsCost,LOCATION_ONFIELD,0,aux.tdcfop(c))
	--code
	aux.EnableChangeCode(c,6007213,LOCATION_MZONE+LOCATION_GRAVE)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c98500010.atkval)
	c:RegisterEffect(e1)
	--immune effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)  -- 自身在怪兽区域才生效
	e3:SetTargetRange(LOCATION_MZONE,0)  -- 己方怪兽区域
	e3:SetTarget(c98500010.etarget)  -- 限定10星以上
	e3:SetValue(c98500010.efilter)  -- 免疫对方陷阱效果
	c:RegisterEffect(e3)
	-- 效果2：全场卡防陷阱取对象
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)  -- 自身在怪兽区域才生效
	e2:SetTargetRange(LOCATION_ONFIELD,0)  -- 己方全场区域
	e2:SetTarget(aux.TargetBoolFunction(Card.IsControler,0))
	e2:SetValue(c98500010.tgval)  -- 防止被对方陷阱取对象
	c:RegisterEffect(e2)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c98500010.discon)
	e4:SetOperation(c98500010.disop)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98500010,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCost(c98500010.descost)
	e5:SetTarget(c98500010.destg)
	e5:SetOperation(c98500010.desop)
	c:RegisterEffect(e5)
end

-- 效果1的目标过滤（10星以上怪兽）
function c98500010.etarget(e,c)
	return c:IsLevelAbove(10) and c:IsControler(e:GetHandlerPlayer())
end

-- 效果1的值函数（免疫对方陷阱效果）
function c98500010.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

-- 效果2的值函数（防止被对方陷阱取对象）
function c98500010.tgval(e,re,rp)
	return re:IsActiveType(TYPE_TRAP) and rp==1-e:GetHandlerPlayer()
end
function c98500010.ffilter(c,fc,sub,mg,sg)
	return c:IsLevel(10)
end
function c98500010.atkval(e,c)
	return Duel.GetMatchingGroupCount(nil,c:GetControler(),LOCATION_ONFIELD,0,nil)*1000
end
function c98500010.etarget(e,c)
	return true
end
function c98500010.efilter(e,re)
	return re:IsActiveType(TYPE_TRAP) and re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c98500010.lvcheck(c)
	return c:IsFaceup() and c:IsLevelAbove(10)
end
function c98500010.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainDisablable(ev) and re:IsActiveType(TYPE_TRAP) and Duel.GetFlagEffect(tp,98500010)<Duel.GetMatchingGroupCount(c98500010.lvcheck,tp,LOCATION_MZONE,0,nil)
end
function c98500010.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(98500010,2)) then
		Duel.Hint(HINT_CARD,0,98500010)
		local rc=re:GetHandler()
		if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
			Duel.Destroy(rc,REASON_EFFECT)
		end
		Duel.RegisterFlagEffect(tp,98500010,RESET_PHASE+PHASE_END,0,1)
	end
end
function c98500010.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 and Duel.GetFlagEffect(tp,985000101)<Duel.GetMatchingGroupCount(c98500010.lvcheck,tp,LOCATION_MZONE,0,nil) end
	--[[local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)]]--
	Duel.RegisterFlagEffect(tp,985000101,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c98500010.desfilter(c)
	return c:IsFacedown()
end
function c98500010.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c98500010.limit(g:GetFirst()))
	end
end
function c98500010.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c98500010.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
