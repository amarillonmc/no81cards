--银河眼滅光波龙
local m=11561076
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),8,2)
	c:EnableReviveLimit()
	--def
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11561076,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c11561076.cost)
	e1:SetTarget(c11561076.target)
	e1:SetOperation(c11561076.operation)
	c:RegisterEffect(e1)
	--neg
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11561076,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c11561076.discost)
	e2:SetTarget(c11561076.distg)
	e2:SetOperation(c11561076.disop)
	c:RegisterEffect(e2)
end
function c11561076.costfilter(c,tp,g)
	return c:IsSetCard(0xe5)
		and Duel.IsExistingMatchingCard(c11561076.NegateFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,Group.FromCards(c))
end
function c11561076.NegateFilter(c)
	return c:IsFaceup() and not c:IsDisabled() and ((c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0) or c:IsType(0x6))
end
function c11561076.fselect(g,tp)
	return Duel.IsExistingMatchingCard(c11561076.NegateFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,g:GetCount(),g)
		and Duel.CheckReleaseGroup(tp,aux.IsInGroup,#g,nil,g)
end
function c11561076.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0xe5)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c11561076.costfilter,1,nil,tp,cg) end
	local rg=Duel.GetReleaseGroup(tp):Filter(c11561076.costfilter,nil,tp,cg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,c11561076.fselect,false,1,rg:GetCount(),tp)
	aux.UseExtraReleaseCount(sg,tp)
	local ct=Duel.Release(sg,REASON_COST)
	e:SetLabel(ct)
end
function c11561076.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=e:GetLabel()
	local g1=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	local g=g1:Filter(c11561076.NegateFilter,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,ct,0,0)
end
function c11561076.disop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local c=e:GetHandler()
	local g1=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	local g=g1:Filter(c11561076.NegateFilter,nil)
	if g:GetCount()>=ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local dg=g:Select(tp,ct,ct,nil)
		Duel.HintSelection(dg)
	local tc=dg:GetFirst()
	while tc do
		if tc:IsFaceup() and tc:IsCanBeDisabledByEffect(e,false) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CHANGE_CODE)
		e4:SetValue(11561077)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
		--[[if tc:IsType(TYPE_MONSTER) then
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e5:SetCode(EFFECT_SET_ATTACK_FINAL)
			e5:SetValue(0)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e5)
			end]]
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_SINGLE)
			e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e6:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e6:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e6)
		end
		end
		tc=dg:GetNext()
	end
	end
end
function c11561076.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c11561076.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c11561076.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EFFECT_SET_ATTACK_FINAL)
	e5:SetValue(0)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e5)
end