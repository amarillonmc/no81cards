local m=98500020
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,32491822,c98500020.ffilter,1,true,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToDeckOrExtraAsCost,LOCATION_ONFIELD,0,aux.tdcfop(c))
	--code
	aux.EnableChangeCode(c,32491822,LOCATION_MZONE+LOCATION_GRAVE)
	--atk limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetValue(c98500020.atlimit)
	c:RegisterEffect(e1)
	--immune effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)  -- 自身在怪兽区域才生效
	e2:SetTargetRange(LOCATION_MZONE,0)  -- 己方怪兽区域
	e2:SetTarget(c98500020.etarget)  -- 限定10星以上
	e2:SetValue(c98500020.efilter)  -- 免疫对方陷阱效果
	c:RegisterEffect(e2)
	--immune effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)  -- 自身在怪兽区域才生效
	e3:SetTargetRange(LOCATION_ONFIELD,0)  -- 己方全场区域
	e3:SetTarget(aux.TargetBoolFunction(Card.IsControler,0))
	e3:SetValue(c98500020.tgval)  -- 防止被对方陷阱取对象
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c98500020.discon)
	e4:SetOperation(c98500020.disop)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_CUSTOM+22222222)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCost(c98500020.descost)
	e5:SetTarget(c98500020.destg)
	e5:SetOperation(c98500020.desop)
	c:RegisterEffect(e5)
	--reg
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(cm.eqcon)
	e6:SetOperation(cm.operation)
	c:RegisterEffect(e6)
	--
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_CHAIN_DISABLED)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c98500020.regcon)
	e7:SetOperation(c98500020.regop2)
	e7:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e7)
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_SUMMON_NEGATED)
	ge1:SetRange(LOCATION_MZONE)
	ge1:SetOperation(cm.checkop)
	c:RegisterEffect(ge1)
	local ge2=ge1:Clone()
	ge2:SetCode(EVENT_SPSUMMON_NEGATED)
	c:RegisterEffect(ge2)
	local ge3 = ge1:Clone()
	ge3:SetCode(EVENT_FLIP_SUMMON_NEGATED)
	c:RegisterEffect(ge3)
end
function c98500020.tgval(e,re,rp)
	return re:IsActiveType(TYPE_SPELL) and rp==1-e:GetHandlerPlayer()
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandlerPlayer()==1-tp
end
function cm.regop2(e,tp,eg,ep,ev,re,r,rp)
	local rc = re:GetHandler()
	Duel.RaiseEvent(rc,EVENT_CUSTOM+22222222,re,r,rp,tp,0)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+22222222,re,r,rp,tp,0)
end
function cm.eqfilter(c,tp)
	return c:GetReasonPlayer()==tp or (c:GetReasonCard() and c:GetReasonCard():IsControler(tp))
end
function cm.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(cm.eqfilter,nil,tp)>0
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local trg= eg:Filter(cm.eqfilter,nil,tp)
	Duel.RaiseEvent(trg,EVENT_CUSTOM+22222222,re,r,rp,tp,0)
end
function c98500020.ffilter(c,fc,sub,mg,sg)
	return c:IsLevel(10)
end
function c98500020.atlimit(e,c)
	return c~=e:GetHandler()
end
function c98500020.etarget(e,c)
	return c:IsLevelAbove(10) and c:IsControler(e:GetHandlerPlayer())
end

-- 效果1的值函数（免疫对方陷阱效果）
function c98500020.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c98500020.lvcheck(c)
	return c:IsFaceup() and c:IsLevelAbove(10)
end
function c98500020.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainDisablable(ev) and re:IsActiveType(TYPE_SPELL) and Duel.GetFlagEffect(tp,22222222)<Duel.GetMatchingGroupCount(c98500020.lvcheck,tp,LOCATION_MZONE,0,nil)
end
function c98500020.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(m,2)) then
		Duel.Hint(HINT_CARD,0,22222222)
		local rc=re:GetHandler()
		if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
			Duel.Destroy(rc,REASON_EFFECT)
		end
		Duel.RegisterFlagEffect(tp,22222222,RESET_PHASE+PHASE_END,0,1)
	end
end
function c98500020.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,222222222)<Duel.GetMatchingGroupCount(c98500020.lvcheck,tp,LOCATION_MZONE,0,nil) end
	Duel.RegisterFlagEffect(tp,222222222,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c98500020.desfilter(c)
	return c:IsFacedown()
end
function c98500020.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c98500020.desop(e,tp,eg,ep,ev,re,r,rp)
	local cg = Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD+LOCATION_GRAVE)
	local cg=cg:Filter(function(c) return c:IsAbleToRemove(tp,POS_FACEDOWN) and eg:IsExists(Card.IsCode,1,nil,c:GetCode())end,nil)
	Duel.ConfirmCards(tp,cg)
	Duel.Remove(cg,POS_FACEDOWN,REASON_EFFECT)
end
