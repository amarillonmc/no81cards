local m=15000340
local cm=_G["c"..m]
cm.name="内核主 欧翡拉·模因"
function cm.initial_effect(c)
	--xyz summon  
	aux.AddXyzProcedure(c,nil,1,2)  
	c:EnableReviveLimit()
	--Overlay
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
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_FREE_CHAIN) 
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCountLimit(1)  
		e1:SetCost(cm.ovcost) 
		e1:SetTarget(cm.ovtg)
		e1:SetOperation(cm.ovop) 
		c:RegisterEffect(e1)  
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))  
	end  
	Debug.Message("被虚构的神啊！从深渊之暗中穿梭前来，逆转寂灭的虚饰吧！")
	Debug.Message("超量召唤，如浮冰般纯净的内核，阶级1！内核主 欧翡拉·模因！")
end
function cm.ovcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanOverlay,tp,LOCATION_MZONE+LOCATION_SZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_SZONE+LOCATION_GRAVE,1,c) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()   
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanOverlay,tp,LOCATION_MZONE+LOCATION_SZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_SZONE+LOCATION_GRAVE,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,Card.IsCanOverlay,tp,LOCATION_MZONE+LOCATION_SZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_SZONE+LOCATION_GRAVE,1,1,c)  
	if g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0) 
	end
end
function cm.ovop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then  
		local og=tc:GetOverlayGroup()  
		if og:GetCount()>0 then  
			Duel.SendtoGrave(og,REASON_RULE)  
		end  
		Duel.Overlay(c,Group.FromCards(tc))  
	end
end