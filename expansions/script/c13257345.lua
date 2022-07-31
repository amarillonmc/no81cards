--超时空武装 主武 博丽符札
local m=13257345
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
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
	e1:SetValue(600)
	c:RegisterEffect(e1)
	--def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(200)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.discon)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
	--equip bomb
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCost(cm.bombcost)
	e4:SetTarget(cm.bombtg)
	e4:SetOperation(cm.bombop)
	c:RegisterEffect(e4)
	eflist={"bomb",e4}
	cm[c]=eflist
	
end
function cm.disfilter(c)
	return c==Duel.GetAttacker() or c==Duel.GetAttackTarget()
end
function cm.eqlimit(e,c)
	return not c:GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x3352)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local f=tama.cosmicFighters_equipGetFormation(e:GetHandler())
	return f and f:IsExists(Card.IsRelateToBattle,1,nil)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local f=tama.cosmicFighters_equipGetFormation(e:GetHandler())
	local ec=f:Filter(cm.disfilter,nil):GetFirst()
	local tc=ec:GetBattleTarget()
	if not tc or ec:IsStatus(STATUS_BATTLE_DESTROYED) or not tc:IsStatus(STATUS_BATTLE_DESTROYED) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x17a0000)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x17a0000)
	tc:RegisterEffect(e2)
end
function cm.bombcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	if chk==0 then return ec and ec:IsCanRemoveCounter(tp,0x351,1,REASON_COST) end
	ec:RemoveCounter(tp,0x351,1,REASON_COST)
end
function cm.bombtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
end
function cm.bombop(e,tp,eg,ep,ev,re,r,rp)
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
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		ec:RegisterEffect(e4,true)
	end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg=g:Select(tp,1,4,nil)
	if tg:GetCount()>0 then
		Duel.HintSelection(tg)
		if Duel.Destroy(tg,REASON_EFFECT)>0 then
			local tc=tg:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESET_EVENT+RESETS_STANDARD-RESET_TOGRAVE-RESET_REMOVE)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESET_EVENT+RESETS_STANDARD-RESET_TOGRAVE-RESET_REMOVE)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_CHAIN_SOLVING)
			e3:SetOperation(cm.disop1)
			e3:SetLabelObject(tc)
			e3:SetReset(RESET_EVENT+RESET_EVENT+RESETS_STANDARD-RESET_TOGRAVE-RESET_REMOVE)
			tc:RegisterEffect(e3)
		end
	end
end
function cm.disop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function cm.efilter1(e,re)
	return e:GetHandler()~=re:GetHandler()
end
