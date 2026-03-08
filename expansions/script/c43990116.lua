--黑兽魁首-卯
local m=43990116
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	c:SetSPSummonOnce(43990116)
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,99)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c43990116.XyzCondition)
	e0:SetTarget(c43990116.XyzTarget)
	e0:SetOperation(c43990116.XyzOperation)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e00:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e00:SetRange(LOCATION_EXTRA)
	e00:SetCode(EVENT_REMOVE)
	e00:SetCondition(c43990116.xyzcon)
	e00:SetOperation(c43990116.xyzop)
	c:RegisterEffect(e00)
	--defup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e1:SetCondition(c43990116.atkcon)
	e1:SetValue(c43990116.defval)
	c:RegisterEffect(e1)
	--defense attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DEFENSE_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--stk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(43990116,0))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,43990116)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c43990116.atkcon)
	e3:SetTarget(c43990116.sttg)
	e3:SetOperation(c43990116.stop)
	c:RegisterEffect(e3)
	
end
function c43990116.xyzconfilter(c,tp)
	return c:IsSetCard(0x6510) and c:IsReason(REASON_EFFECT)
end
function c43990116.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c43990116.xyzconfilter,1,nil,tp) and (re and re:GetHandler():IsSetCard(0x6510))
end
function c43990116.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=nil
	local og=Duel.GetMatchingGroup(c43990116.Xyzfilter,tp,LOCATION_REMOVED,0,nil,c)
	c:RegisterFlagEffect(43990116,0,0,1,0)
	if not c:IsXyzSummonable(og,2,99) then return end
	if Duel.SelectYesNo(tp,aux.Stringid(43990116,2)) then
	c:ResetFlagEffect(43990116)
		c43990116.XyzTarget(e,tp,eg,ep,ev,re,r,rp,chk,c)
		c43990116.XyzOperation(e,tp,eg,ep,ev,re,r,rp,c)
		Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	end
end
function c43990116.Xyzfilter(c,sc)
	return c:IsSetCard(0x6510) and c:IsFaceupEx() and c:IsCanBeXyzMaterial(sc) and c:IsXyzLevel(sc,4)
end
function c43990116.XyzCondition(e,tp,eg,ep,ev,re,r,rp,chk,c,og)
	local c=e:GetHandler()
	return not c:GetFlagEffect(43990116)
end
function c43990116.XyzTarget(e,tp,eg,ep,ev,re,r,rp,chk,c,og)
	local g=Group.CreateGroup()
	if og then 
		g=Duel.SelectXyzMaterial(tp,c,aux.FilterBoolFunction(Card.IsSetCard,0x6510),4,2,99,og)
	else
		local og=Duel.GetMatchingGroup(c43990116.Xyzfilter,tp,LOCATION_REMOVED,0,nil,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=og:Select(tp,2,99,nil)
	end
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c43990116.XyzOperation(e,tp,eg,ep,ev,re,r,rp,c,og)
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
		e1:SetDescription(aux.Stringid(43990116,3))
		e1:SetCategory(CATEGORY_REMOVE)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetTarget(c43990116.rmtg)
		e1:SetOperation(c43990116.rmop)
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
		e1:SetDescription(aux.Stringid(43990116,3))
		e1:SetCategory(CATEGORY_REMOVE)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetTarget(c43990116.rmtg)
		e1:SetOperation(c43990116.rmop)
		e1:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e1)
	end
end
function c43990116.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c43990116.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 and c:GetOriginalCode()==43990116 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c43990116.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c43990116.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c43990116.atkcon(e)
	return e:GetHandler():GetOverlayCount()==0
end
function c43990116.defval(e,c)
	return c:GetDefense()*2
end
function c43990116.stfilter(c,tc)
	return c:IsCanBeBattleTarget(tc) 
end
function c43990116.sttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c43990116.stfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c43990116.stfilter,tp,0,LOCATION_MZONE,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c43990116.stfilter,tp,0,LOCATION_MZONE,1,1,nil,c)
end
function c43990116.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) and tc:IsCanBeBattleTarget(c) and tc:IsControler(1-tp) and tc:IsLocation(LOCATION_MZONE) and c:IsRelateToEffect(e) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_MZONE) then
		Duel.CalculateDamage(c,tc)
	end
end
