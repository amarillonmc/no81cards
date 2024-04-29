--银河眼扩散光波龙
local m=22348406
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,2,c22348406.ovfilter,aux.Stringid(22348406,0),2,c22348406.xyzop)
	c:EnableReviveLimit()
	--cannot be effect target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(aux.tgoval)
	e1:SetCondition(c22348406.wfcon)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.indoval)
	e2:SetCondition(c22348406.wfcon)
	c:RegisterEffect(e2)
	--negate activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348406,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_HANDES+CATEGORY_CONTROL)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c22348406.nacon)
	e3:SetCost(c22348406.nacost)
	e3:SetTarget(c22348406.natg)
	e3:SetOperation(c22348406.naop)
	c:RegisterEffect(e3)
end
	
function c22348406.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10e5)
end
function c22348406.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,22348406)==0 end
	Duel.RegisterFlagEffect(tp,22348406,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c22348406.wfcon(e)
	return e:GetHandler():GetOverlayCount()~=0
end
function c22348406.nacon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp and loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c22348406.nacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22348406.natg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=re:GetHandler()
	if chk==0 then return c:IsControlerCanBeChanged() and c:IsRelateToEffect(re) and not c:IsStatus(STATUS_BATTLE_DESTROYED) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,re:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,re:GetHandler(),1,0,0)
end
function c22348406.naop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=re:GetHandler()
	if Duel.NegateActivation(ev) and tc:IsRelateToEffect(re) and not tc:IsStatus(STATUS_BATTLE_DESTROYED) and not tc:IsImmuneToEffect(e) and tc:IsControlerCanBeChanged() then
		if tc:IsFaceup() then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_SET_ATTACK_FINAL)
			e4:SetValue(4200)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e4)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_CHANGE_CODE)
			e5:SetValue(22348406)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e5)
		end
		Duel.GetControl(tc,tp)
	end
end
