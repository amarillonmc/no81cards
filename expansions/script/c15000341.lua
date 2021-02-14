local m=15000341
local cm=_G["c"..m]
cm.name="内核龙 卡欧斯·情景"
function cm.initial_effect(c)
	--xyz summon  
	aux.AddXyzProcedure(c,nil,1,2)  
	c:EnableReviveLimit()
	--NegateEffect
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetCondition(cm.tncon)  
	e1:SetOperation(cm.tnop)  
	c:RegisterEffect(e1)  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_MATERIAL_CHECK)  
	e2:SetValue(cm.valcheck)  
	e2:SetLabelObject(e1)  
	c:RegisterEffect(e2)
	--battle  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE)  
	e3:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)  
	e3:SetValue(1)  
	c:RegisterEffect(e3)  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_SINGLE)  
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)  
	e4:SetValue(1)  
	c:RegisterEffect(e4)
end
function cm.valcheck(e,c)  
	local flag=0  
	local g=c:GetMaterial()  
	if g:GetCount()>0 and not g:IsExists(cm.mfilter,1,nil) then  
		flag=flag|2  
	end  
	e:GetLabelObject():SetLabel(flag)  
end  
function cm.mfilter(c)  
	return not c:IsSetCard(0xf39)
end  
function cm.tncon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetLabel()>0  
end  
function cm.tnop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()   
	if e:GetLabel()&2==2 then  
		--negate  
		local e3=Effect.CreateEffect(c)  
		e3:SetCategory(CATEGORY_NEGATE+CATEGORY_TOGRAVE)  
		e3:SetType(EFFECT_TYPE_QUICK_O)  
		e3:SetCode(EVENT_CHAINING)  
		e3:SetCountLimit(1)  
		e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)  
		e3:SetRange(LOCATION_MZONE)  
		e3:SetCondition(cm.discon)  
		e3:SetCost(cm.discost)  
		e3:SetTarget(cm.distg)  
		e3:SetOperation(cm.disop)  
		c:RegisterEffect(e3) 
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))  
	end  
	Debug.Message("异界的龙啊！挣碎罪业掀起的无尽虚空，从收容的裂缝中飞出吧！")
	Debug.Message("超量召唤，如灵魂般纯白的内核，阶级1！内核龙 卡欧斯·情景！")
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)  
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainDisablable(ev)  
end  
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
end  
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)  
	if re:GetHandler():IsAbleToGrave() and re:GetHandler():IsRelateToEffect(re) then  
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,eg,1,0,0)  
	end  
end  
function cm.disop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then  
		Duel.SendtoGrave(eg,REASON_EFFECT)  
	end  
end