local m=15000096
local cm=_G["c"..m]
cm.name="无轶之骑士·帝骑"
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,3)
	c:EnableReviveLimit()
	--Overlay
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(cm.tncon)
	e0:SetOperation(cm.tnop)
	c:RegisterEffect(e0)
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetCondition(cm.copycon1)
	e1:SetValue(cm.copyval)
	c:RegisterEffect(e1)
	--CopyEffect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetCondition(cm.copycon2)
	e2:SetOperation(cm.copyop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_ADJUST)
	e3:SetCondition(cm.regcon)
	e3:SetOperation(cm.regop)
	c:RegisterEffect(e3)
	--material  
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetTarget(cm.mttg)
	e4:SetOperation(cm.mtop)
	c:RegisterEffect(e4)
	--adjust
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(cm.adjustop)
	c:RegisterEffect(e5)
end
function cm.tncon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end 
function cm.tnop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("一个路过的假面骑士罢了，给我记住了")
end
function cm.copycon1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup()
	return g:GetCount()==1 and g:GetFirst():IsType(TYPE_MONSTER) and e:GetHandler():IsFaceup()
end
function cm.copyval(e)
	return e:GetHandler():GetOverlayGroup():GetFirst():GetOriginalCode()
end
function cm.copycon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	return g:GetCount()==1 and g:GetFirst():IsType(TYPE_MONSTER) and c:GetFlagEffectLabel(m)==nil
end
function cm.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetHandler():GetOverlayGroup()
	local tc=g:GetFirst()
Debug.Message("KamenRide")
	local cid=c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD,1)
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,tc:GetOriginalCode())
	c:RegisterFlagEffect(15010096,RESET_EVENT+RESETS_STANDARD,0,1,cid)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	local tc=g:GetFirst()
	return c:GetFlagEffectLabel(m)~=nil and (g:GetCount()==0 or c:GetFlagEffectLabel(m)~=tc:GetOriginalCode() or g:GetCount()>1) and c:GetFlagEffect(15000097)==0
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	local tc=g:GetFirst()
	if tc and tc:GetOriginalCode()==c:GetFlagEffectLabel(m) then return end
	local cid=c:GetFlagEffectLabel(15010096)
	c:ResetEffect(cid,RESET_COPY)
	c:ResetFlagEffect(m)
	c:ResetFlagEffect(15010096)
end
function cm.mtfilter(c)  
	return c:IsType(TYPE_MONSTER) and c:IsCanOverlay() and not c:IsCode(15000096)
end  
function cm.mttg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(cm.mtfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end  
end  
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end  
Debug.Message("跟你打的话，用这张比较好")
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)  
	local g=Duel.SelectMatchingCard(tp,cm.mtfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)  
	c:RegisterFlagEffect(15000097,RESET_PHASE+PHASE_END,0,99)
	if g:GetCount()>0 then  
		Duel.Overlay(c,g)
	end  
end
function cm.adfilter(c)
	return c:IsType(TYPE_XYZ) and c:GetOverlayCount()>1
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local sg=Group.CreateGroup()
	for p=0,1 do
		local g=Duel.GetMatchingGroup(cm.adfilter,p,LOCATION_MZONE,0,nil)
		local tc=g:GetFirst()
		while tc do
			if tc:GetOverlayCount()>1 then sg:AddCard(tc) end
			while tc:GetOverlayCount()>1 do
				tc:RemoveOverlayCard(p,1,1,REASON_RULE)
			end
			if tc:GetFlagEffect(15000097)~=0 then tc:ResetFlagEffect(15000097) end
			tc=g:GetNext()
		end
	end
	if sg:GetCount()~=0 then
		Duel.Readjust()
	end
end