--黑兽魁首-酉
local m=43990118
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	c:SetSPSummonOnce(43990118)
	aux.AddXyzProcedure(c,nil,4,6,nil,nil,99)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c43990118.XyzCondition)
	e0:SetTarget(c43990118.XyzTarget)
	e0:SetOperation(c43990118.XyzOperation)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e00:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e00:SetRange(LOCATION_EXTRA)
	e00:SetCode(EVENT_REMOVE)
	e00:SetCondition(c43990118.xyzcon)
	e00:SetOperation(c43990118.xyzop)
	c:RegisterEffect(e00)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c43990118.atkcon)
	e1:SetValue(c43990118.efilter)
	c:RegisterEffect(e1)
	--defense attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DEFENSE_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--dr
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(43990118,0))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,43990118)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c43990118.atkcon)
	e3:SetTarget(c43990118.drtg)
	e3:SetOperation(c43990118.drop)
	c:RegisterEffect(e3)
	
end
function c43990118.xyzconfilter(c,tp)
	return c:IsSetCard(0x6510) and c:IsReason(REASON_EFFECT)
end
function c43990118.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c43990118.xyzconfilter,1,nil,tp) and (re and re:GetHandler():IsSetCard(0x6510))
end
function c43990118.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=nil
	local og=Duel.GetMatchingGroup(c43990118.Xyzfilter,tp,LOCATION_REMOVED,0,nil,c)
	c:RegisterFlagEffect(43990118,0,0,1,0)
	if not c:IsXyzSummonable(og,6,99) then return end
	if Duel.SelectYesNo(tp,aux.Stringid(43990118,2)) then
	c:ResetFlagEffect(43990118)
		c43990118.XyzTarget(e,tp,eg,ep,ev,re,r,rp,chk,c)
		c43990118.XyzOperation(e,tp,eg,ep,ev,re,r,rp,c)
		Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		c:CompleteProcedure()
	end
end
function c43990118.Xyzfilter(c,sc)
	return c:IsSetCard(0x6510) and c:IsFaceupEx() and c:IsCanBeXyzMaterial(sc) and c:IsXyzLevel(sc,4)
end
function c43990118.XyzCondition(e,tp,eg,ep,ev,re,r,rp,chk,c,og)
	local c=e:GetHandler()
	return not c:GetFlagEffect(43990118)
end
function c43990118.XyzTarget(e,tp,eg,ep,ev,re,r,rp,chk,c,og)
	local g=Group.CreateGroup()
	if og then 
		g=Duel.SelectXyzMaterial(tp,c,aux.FilterBoolFunction(Card.IsSetCard,0x6510),4,6,99,og)
	else
		local og=Duel.GetMatchingGroup(c43990118.Xyzfilter,tp,LOCATION_REMOVED,0,nil,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=og:Select(tp,6,99,nil)
	end
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c43990118.XyzOperation(e,tp,eg,ep,ev,re,r,rp,c,og)
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
		e1:SetDescription(aux.Stringid(43990118,3))
		e1:SetCategory(CATEGORY_REMOVE)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetTarget(c43990118.rmtg)
		e1:SetOperation(c43990118.rmop)
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
		e1:SetDescription(aux.Stringid(43990118,3))
		e1:SetCategory(CATEGORY_REMOVE)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetTarget(c43990118.rmtg)
		e1:SetOperation(c43990118.rmop)
		e1:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e1)
	end
end
function c43990118.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c43990118.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 and c:GetOriginalCode()==43990118 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c43990118.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c43990118.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c43990118.atkcon(e)
	return e:GetHandler():GetOverlayCount()==0
end
function c43990118.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c43990118.drfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x6510) and c:IsAbleToDeck()
end
function c43990118.drfilter1(c,e)
	return c43990118.drfilter(c) and c:IsCanBeEffectTarget(e)
end
function c43990118.drfilter2(c)
	return c:IsAbleToRemove()
end
function c43990118.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c43990118.drfilter(chkc) end
	local ct1=Duel.GetMatchingGroupCount(c43990118.drfilter1,tp,LOCATION_REMOVED,0,nil,e)
	local ct2=Duel.GetMatchingGroupCount(c43990118.drfilter2,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return ct1>0 and ct2>0 end
	local ct=math.min(ct1,ct2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c43990118.drfilter,tp,LOCATION_REMOVED,0,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,0,0,0,0)
end
function c43990118.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
		if ct>0 and Duel.IsExistingMatchingCard(c43990118.drfilter2,tp,0,LOCATION_ONFIELD,ct,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local hg=Duel.SelectMatchingCard(tp,c43990118.drfilter2,tp,0,LOCATION_ONFIELD,ct,ct,nil)
			Duel.HintSelection(hg)
			Duel.Remove(hg,nil,REASON_EFFECT)
			if c:IsRelateToEffect(e) and c:IsFaceup() then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
				e1:SetValue(ct*1000)
				c:RegisterEffect(e1)
			end
		end
	end

end


