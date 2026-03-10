--黑兽-卯-其二
local m=43990119
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	c:SetSPSummonOnce(43990119)
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,99)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c43990119.XyzCondition)
	e0:SetTarget(c43990119.XyzTarget)
	e0:SetOperation(c43990119.XyzOperation)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e00:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e00:SetRange(LOCATION_EXTRA)
	e00:SetCode(EVENT_REMOVE)
	e00:SetCondition(c43990119.xyzcon)
	e00:SetOperation(c43990119.xyzop)
	c:RegisterEffect(e00)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c43990119.atkcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--defense attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DEFENSE_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--tm
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(43990119,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,43990119)
	e3:SetTarget(c43990119.tmtg)
	e3:SetOperation(c43990119.tmop)
	c:RegisterEffect(e3)
	
end
function c43990119.xyzconfilter(c,tp)
	return c:IsSetCard(0x6510) and c:IsReason(REASON_EFFECT)
end
function c43990119.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c43990119.xyzconfilter,1,nil,tp) and (re and re:GetHandler():IsSetCard(0x6510))
end
function c43990119.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=nil
	local og=Duel.GetMatchingGroup(c43990119.Xyzfilter,tp,LOCATION_REMOVED,0,nil,c)
	c:RegisterFlagEffect(43990119,0,0,1,0)
	if not c:IsXyzSummonable(og,2,99) then return end
	if Duel.SelectYesNo(tp,aux.Stringid(43990119,2)) then
	c:ResetFlagEffect(43990119)
		c43990119.XyzTarget(e,tp,eg,ep,ev,re,r,rp,chk,c)
		c43990119.XyzOperation(e,tp,eg,ep,ev,re,r,rp,c)
		Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		c:CompleteProcedure()
	end
end
function c43990119.Xyzfilter(c,sc)
	return c:IsSetCard(0x6510) and c:IsFaceupEx() and c:IsCanBeXyzMaterial(sc) and c:IsXyzLevel(sc,4)
end
function c43990119.XyzCondition(e,tp,eg,ep,ev,re,r,rp,chk,c,og)
	local c=e:GetHandler()
	return not c:GetFlagEffect(43990119)
end
function c43990119.XyzTarget(e,tp,eg,ep,ev,re,r,rp,chk,c,og)
	local g=Group.CreateGroup()
	if og then 
		g=Duel.SelectXyzMaterial(tp,c,aux.FilterBoolFunction(Card.IsSetCard,0x6510),4,2,99,og)
	else
		local og=Duel.GetMatchingGroup(c43990119.Xyzfilter,tp,LOCATION_REMOVED,0,nil,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=og:Select(tp,2,99,nil)
	end
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c43990119.XyzOperation(e,tp,eg,ep,ev,re,r,rp,c,og)
	if og then
		local sg=Group.CreateGroup()
		local tc=og:GetFirst()
		while tc do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
			tc=og:GetNext()
		end
			Duel.SendtoGrave(sg,REASON_RULE)
			c:SetMaterial(og)
			Duel.Overlay(c,og)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(43990119,3))
		e1:SetCategory(CATEGORY_REMOVE)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetTarget(c43990119.rmtg)
		e1:SetOperation(c43990119.rmop)
		e1:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e1)
	else
		local mg=e:GetLabelObject()
		local sg=Group.CreateGroup()
		local tc=mg:GetFirst()
		while tc do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
			tc=mg:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(mg)
		Duel.Overlay(c,mg)
		mg:DeleteGroup()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(43990119,3))
		e1:SetCategory(CATEGORY_REMOVE)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetTarget(c43990119.rmtg)
		e1:SetOperation(c43990119.rmop)
		e1:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e1)
	end
end
function c43990119.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c43990119.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 and c:GetOriginalCode()==43990119 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c43990119.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c43990119.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c43990119.atkcon(e)
	return e:GetHandler():GetOverlayCount()==0
end
function c43990119.tempfilter(c)
	return c:IsLocation(LOCATION_REMOVED) and c:IsReason(REASON_TEMPORARY) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c43990119.tffilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6510) and c43990119.tempfilter(c) and c43990119.retfilter(c)
end
function c43990119.retfilter(c)
	local p=c:GetPreviousControler()
	return Duel.GetLocationCount(p,LOCATION_MZONE)>0
end
function c43990119.tmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c43990119.tffilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c43990119.tffilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectTarget(tp,c43990119.tffilter,tp,LOCATION_REMOVED,0,1,1,nil)
end
function c43990119.tmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local rc=tc
		if tc:GetReasonEffect() then rc=tc:GetReasonEffect():GetOwner() end
		local e1=Effect.CreateEffect(rc)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(43990119)
		e1:SetLabelObject(tc)
		e1:SetOperation(c43990119.retop3)
		Duel.RegisterEffect(e1,0)
		Duel.RaiseEvent(tc,43990119,e,0,0,0,0)
		e1:Reset()
	end
end
function c43990119.retop3(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
	e:Reset()
end
