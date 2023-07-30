--喷射炮手
local m=60002232
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
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(cm.cos5)
	e5:SetOperation(cm.op5)
	c:RegisterEffect(e5)
	
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
	local g=Duel.SelectMatchingCard(tp,cm.cos5f1,tp,LOCATION_GRAVE,0,2,99,nil)
	e:SetLabel(Duel.SendtoDeck(g,tp,2,REASON_COST))
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local dam=e:GetLabel()
	if not e:GetHandler():IsRelateToEffect(e) or not e:GetHandler():IsFaceup() then return end
	if dam==2 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1600)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e:GetHandler():RegisterEffect(e1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(1600)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e:GetHandler():RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
		e2:SetValue(1)
		c:RegisterEffect(e2)
	end
	if dam>=3 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(3200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e:GetHandler():RegisterEffect(e1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(3200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e:GetHandler():RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
		e2:SetValue(2)
		c:RegisterEffect(e2)
	end
end