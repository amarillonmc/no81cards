local m=53750001
local cm=_G["c"..m]
cm.name="彻乐之森的豪士"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(cm.ntcon)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(cm.tgcon)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(cm.condition)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
end
function cm.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_NORMAL+SUMMON_VALUE_SELF
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_HAND)
	Duel.SetChainLimit(function(e,ep,tp)return tp==ep end)
end
function cm.thfilter(c)
	return c:IsSetCard(0x9532) and c:IsAbleToHand()
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,nil,2,2,REASON_EFFECT,nil)~=0 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function cm.costfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:GetType()==TYPE_SPELL and c:IsAbleToGraveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c):GetFirst()
	Duel.SendtoGrave(Group.FromCards(c,tc),REASON_COST)
	local rc=re:GetHandler()
	if rc:IsType(TYPE_EFFECT) and tc:IsLocation(LOCATION_GRAVE) and tc:GetActivateEffect() then
		if rc:GetFlagEffect(m)==0 then rc:RegisterFlagEffect(m,RESET_CHAIN,0,1) end
		local le={tc:GetActivateEffect()}
		local ct=#le
		local ch=Duel.GetCurrentChain()
		for i,te in pairs(le) do
			local e1=Effect.CreateEffect(rc)
			if ct==1 then e1:SetDescription(aux.Stringid(m,2)) else e1:SetDescription(te:GetDescription()) end
			e1:SetCategory(te:GetCategory())
			e1:SetType(EFFECT_TYPE_QUICK_O)
			e1:SetCode(EVENT_FREE_CHAIN)
			e1:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
			e1:SetProperty(te:GetProperty())
			e1:SetLabel(1<<ch)
			e1:SetLabelObject(tc)
			e1:SetValue(i)
			e1:SetTarget(cm.spelltg)
			e1:SetOperation(cm.spellop)
			e1:SetReset(RESET_CHAIN)
			rc:RegisterEffect(e1)
		end
	end
end
function cm.spelltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local t={e:GetLabelObject():GetActivateEffect()}
	local ae=t[e:GetValue()]
	local ftg=ae:GetTarget()
	local flag=e:GetHandler():GetFlagEffectLabel(m)
	if chk==0 then
		e:SetCostCheck(false)
		return (not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk)) and bit.band(flag,e:GetLabel())==0
	end
	e:GetHandler():SetFlagEffectLabel(m,flag|e:GetLabel())
	if ftg then
		e:SetCostCheck(false)
		ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function cm.spellop(e,tp,eg,ep,ev,re,r,rp)
	local t={e:GetLabelObject():GetActivateEffect()}
	local ae=t[e:GetValue()]
	local fop=ae:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
