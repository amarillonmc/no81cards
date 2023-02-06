local m=53753012
local cm=_G["c"..m]
cm.name="生祭的异铜"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(0x10000000+53753000)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(cm.con)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
end
cm.has_text_type=TYPE_DUAL
function cm.con(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(aux.NOT(Card.IsSummonableCard),tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(aux.NOT(Card.IsSummonableCard),tp,0,LOCATION_MZONE,1,nil)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function cm.filter(c)
	return SNNM.multi_summon_count(Group.FromCards(c))>0
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return (Duel.IsPlayerCanDraw(tp,1) or Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil)) and Duel.CheckReleaseGroup(tp,cm.filter,1,nil,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,cm.filter,1,1,nil,tp)
	e:SetLabel(SNNM.multi_summon_count(rg))
	Duel.Release(rg,REASON_COST)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsPlayerCanDraw(tp,1)
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil)
	local opt=0
	if b1 and b2 then opt=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2)) elseif b1 then opt=Duel.SelectOption(tp,aux.Stringid(m,1)) elseif b2 then opt=Duel.SelectOption(tp,aux.Stringid(m,2))+1 else return end
	local ct=e:GetLabel()
	while ct>0 do
		ct=ct-1
		local res=0
		if b1 and opt%2==0 then
			res=Duel.Draw(tp,1,REASON_EFFECT)
			if not b2 then res=0 end
		end
		if b2 and opt%2~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoGrave(sg,REASON_EFFECT)
			res=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
			if not b1 then res=0 end
		end
		if ct==0 or res==0 or not Duel.SelectYesNo(tp,aux.Stringid(m,3)) then break else opt=1-opt end
	end
end
