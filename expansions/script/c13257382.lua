--超时空武装 主武-闪光剑
local m=13257382
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--equip limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_EQUIP_LIMIT)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetValue(cm.eqlimit)
	c:RegisterEffect(e11)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	--def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.negcon)
	e3:SetOperation(cm.negop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(cm.descost)
	e4:SetTarget(cm.destg)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
	eflist={{"bomb",e4},{"power_charge",e4}}
	cm[c]=eflist
	
end
function cm.eqlimit(e,c)
	return not c:GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x3352) and c:IsSummonableCard()
end
function cm.tfilter(c,ec)
	local eg=ec:GetEquipGroup()
	return c==ec or (eg and eg:IsContains(c))
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
		and g and g:IsExists(cm.tfilter,1,nil,ec)
		and Duel.IsChainDisablable(ev) and not Duel.IsChainDisabled(ev)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateEffect(ev) then
		if c:GetFlagEffect(m)<=0 then
			c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,0)
		end
		c:SetFlagEffectLabel(m,ct+1)
		local ct=c:GetFlagEffectLabel(m)
		if ct==3+tama.cosmicFighters_getPowerChargeBuff(c) then
			Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(m,1))
		end
		Duel.BreakEffect()
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function cm.efilter(e,te)
	return e:GetHandler()~=te:GetOwner() and not te:GetOwner():IsType(TYPE_EQUIP)
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(m) and c:GetFlagEffectLabel(m)>=3+tama.cosmicFighters_getPowerChargeBuff(c) end
	c:ResetFlagEffect(m)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if not c:IsRelateToEffect(e) then return end
	if ec then
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetValue(cm.efilter1)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		ec:RegisterEffect(e4,true)
	end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil,ec)
	local tc=g:GetFirst()
	if g:GetCount()>0 then
		while tc do
			if tc:IsFaceup() and tc:IsCanBeDisabledByEffect(e) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
				if tc:IsType(TYPE_TRAPMONSTER) then
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e3)
				end
				Duel.AdjustInstantly()
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			end
			tc=g:GetNext()
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
	end
end
