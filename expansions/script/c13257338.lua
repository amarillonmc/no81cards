--梦超时空战斗机-雾雨 魔理沙
local m=13257338
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	c:EnableCounterPermit(0x351)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(cm.addc)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Power Capsule
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.pccon)
	e3:SetTarget(cm.pctg)
	e3:SetOperation(cm.pcop)
	c:RegisterEffect(e3)
	--bomb
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,6))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetCost(cm.bombcost)
	e4:SetOperation(cm.bombop)
	c:RegisterEffect(e4)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	e11:SetOperation(cm.bgmop)
	c:RegisterEffect(e11)
	eflist={{"power_capsule",e3},{"bomb",e4}}
	cm[c]=eflist
	
end
function cm.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsCanAddCounter(0x351,1) then
		e:GetHandler():AddCounter(0x351,1)
	end
end
function cm.eqfilter(c,ec)
	return c:IsSetCard(0x352) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function cm.pcfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function cm.pccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.pcfilter,1,nil,1-tp)
end
function cm.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	e:SetCategory(CATEGORY_EQUIP)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
end
function cm.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,cm.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.Equip(tp,tc,c)
	end
end
function cm.bombcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x351,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x351,1,REASON_COST)
end
function cm.desfilter(c,ec)
	return ec:GetColumnGroup():IsContains(c)
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.bombop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_ONFIELD,nil,e:GetHandler())
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetValue(cm.efilter)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e4)
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_UPDATE_ATTACK)
		e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e5:SetValue(700)
		c:RegisterEffect(e5)
		--damage
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAINING)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e3:SetOperation(cm.regop)
		c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_CHAIN_SOLVED)
		e4:SetRange(LOCATION_MZONE)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e4:SetCondition(cm.accon)
		e4:SetOperation(cm.acop)
		c:RegisterEffect(e4)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler() then
		e:GetHandler():RegisterFlagEffect(m+1,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
	end
end
function cm.accon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c and ep~=tp
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(m)==0 then 
		c:RegisterFlagEffect(m,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,0,1,1)
	else
		local label=c:GetFlagEffectLabel(m)
		c:SetFlagEffectLabel(m,label+c:GetFlagEffect(m+1))
	end
	if c:GetFlagEffectLabel(m)>=3 then
		Duel.Hint(HINT_CARD,1,m)
		c:AddCounter(0x351,1)
		c:SetFlagEffectLabel(m,0)
	end
end
function cm.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(m,7))
end
