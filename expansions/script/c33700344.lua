--虚拟YouTuber Mirai Akari
local m=33700344
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.dfc_front_side=m+1
function cm.initial_effect(c)
	aux.AddSynchroMixProcedure(c,aux.TRUE,nil,nil,aux.TRUE,2,63,function(g)
		return g:IsExists(aux.Tuner(nil),1,nil) and g:IsExists(aux.NonTuner(nil),1,nil)
	end)
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.mtcon)
	e2:SetOperation(cm.mtop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(cm.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
		local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		if not g then return false end
		local tc=g:GetFirst()
		local c=e:GetHandler()
		local ex,tg,tc_=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
		return not c:IsStatus(STATUS_BATTLE_DESTROYED) and g:IsContains(c) and (not ex or not tg or not tg:IsContains(c))
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Senya.IsDFCTransformable(e:GetHandler()) end
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if c:IsFaceup() and c:IsRelateToEffect(e) and Senya.IsDFCTransformable(c) then
			c:ReleaseEffectRelation(re)
			Senya.TransformDFCCard(c)
		end
	end)
	c:RegisterEffect(e1)
end
function cm.mfilter(c)
	return c:IsType(TYPE_TUNER)
end
function cm.mfilter1(c)
	return not c:IsType(TYPE_TUNER)
end
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=g:FilterCount(cm.mfilter,nil)
	local ct2=g:FilterCount(cm.mfilter1,nil)
	e:GetLabelObject():SetLabel(ct | (ct2 << 8))
end
function cm.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()>0
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel() & 0xff
	local ct2=e:GetLabel() >> 8
	if ct>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(function(e,re,r,rp)
			return bit.band(r,REASON_BATTLE)~=0
		end)
		e1:SetCountLimit(ct)
		c:RegisterEffect(e1)
	end
	if ct2>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(function(e,re,r,rp)
			return bit.band(r,REASON_EFFECT)~=0
		end)
		e1:SetCountLimit(ct2)
		c:RegisterEffect(e1)
	end
end