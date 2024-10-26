local m=53799075
local cm=_G["c"..m]
cm.name="天锥"
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,nil,12,3)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e0:SetTargetRange(POS_FACEUP,1)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1)
	e0:SetCondition(cm.con)
	e0:SetTarget(cm.tg)
	e0:SetOperation(cm.op)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetCondition(cm.lcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(cm.efop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_CODE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.lcon)
	e4:SetValue(cm.val)
	c:RegisterEffect(e4)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e6:SetCountLimit(1)
	e6:SetOperation(cm.lpop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetCondition(cm.lcon)
	e7:SetValue(cm.efilter)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_MUST_USE_MZONE)
	e8:SetValue(cm.frcval)
	c:RegisterEffect(e8)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsRelateToEffect(re) or not re:IsActiveType(TYPE_MONSTER) then return end
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if loc==LOCATION_MZONE then
		rc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.frcval(e,c,fp,rp,r)
	return 0x1f001f
end
function cm.xyzfilter(c,e)
	return c:GetFlagEffect(m)~=0 and c:IsCanBeXyzMaterial(e:GetHandler()) and Duel.GetMZoneCount(1-c:GetControler(),c,c:GetControler())>0
end
function cm.con(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(cm.xyzfilter,c:GetControler(),0,LOCATION_MZONE,1,nil,e) and Duel.GetFlagEffect(c:GetControler(),m)==0
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	local g=Duel.GetMatchingGroup(cm.xyzfilter,tp,0,LOCATION_MZONE,nil,e)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local xg=g:Select(tp,1,1,nil)
		xg:KeepAlive()
		e:SetLabelObject(xg)
	return true
	else return false end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local mg=e:GetLabelObject()
	local mg2=mg:GetFirst():GetOverlayGroup()
	if mg2:GetCount()~=0 then
		Duel.SendtoGrave(mg2,REASON_RULE)
	end
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
	mg:DeleteGroup()
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function cm.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cpe,cpc=e:GetLabel(),e:GetLabelObject()
	local og=c:GetOverlayGroup()
	local oc=og:GetFirst()
	if (not oc and cpc) or (oc and not (oc:IsType(TYPE_MONSTER) and #og==1) and cpc) then
		c:ResetEffect(cpe,RESET_COPY)
		e:SetLabel(0)
		e:SetLabelObject(nil)
		return
	end
	if oc and oc:IsType(TYPE_MONSTER) and #og==1 and cpc and cpc~=oc then
		c:ResetEffect(cpe,RESET_COPY)
		e:SetLabel(0)
		e:SetLabelObject(nil)
	end
	if oc and oc:IsType(TYPE_MONSTER) and oc:IsType(TYPE_EFFECT) and not oc:IsType(TYPE_TRAPMONSTER) and not e:GetLabelObject() then
		cpe=c:CopyEffect(oc:GetOriginalCode(),RESET_EVENT+0x1fe0000,1)
		e:SetLabel(cpe)
		e:SetLabelObject(oc)
	end
end
function cm.lcon(e)
	local g=e:GetHandler():GetOverlayGroup()
	return g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) and #g==1
end
function cm.val(e,c)
	local g=e:GetHandler():GetOverlayGroup()
	return g:GetFirst():GetCode()
end
function cm.mtfilter(c,e)
	return c:IsFaceup() and c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e))
end
function cm.lpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local lp=Duel.GetLP(1-tp)
	Duel.SetLP(1-tp,lp-2500)
	if Duel.GetLP(1-tp)<=0 and not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_CANNOT_LOSE_KOISHI) then return end
	Duel.BreakEffect()
	if c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,cm.mtfilter,tp,LOCATION_MZONE,0,1,1,c,e)
	if g:GetCount()>0 then Duel.Overlay(c,g) end
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
