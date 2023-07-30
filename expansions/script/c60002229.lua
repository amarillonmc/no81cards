--精炼保镳
local m=60002229
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,60002223)
	--爆能强化
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetValue(SUMMON_TYPE_ADVANCE)
	e2:SetCondition(cm.con2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	--进化
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(cm.cos5)
	e5:SetOperation(cm.op5)
	c:RegisterEffect(e5)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER+CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(cm.cost)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
function cm.con2(e,c,minc)
	if c==nil then return true end
	return minc<=1 and Duel.CheckTribute(c,1)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp,c)
	g=Duel.SelectTribute(tp,c,1,Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE))
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
	for tc in aux.Next(g) do
		if tc:IsLocation(LOCATION_GRAVE) then 
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	end
end
function cm.cos5f1(c)
	return c:GetFlagEffect(m)>0 and (c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost())
end
function cm.cos5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cos5f1,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.cos5f1,tp,LOCATION_GRAVE,0,2,2,nil)
	e:SetLabel(Duel.SendtoDeck(g,tp,2,REASON_COST))
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or not e:GetHandler():IsFaceup() then return end
	Duel.Draw(tp,2,REASON_EFFECT)
	Duel.Recover(tp,2000,REASON_EFFECT)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,60002223) then
			Duel.Draw(tp,1,REASON_EFFECT)
			Duel.Recover(tp,1000,REASON_EFFECT)
		end
	end
end