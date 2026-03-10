--黑兽魁首-午
local m=43990117
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	c:SetSPSummonOnce(43990117)
	aux.AddXyzProcedure(c,nil,4,4,nil,nil,99)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c43990117.XyzCondition)
	e0:SetTarget(c43990117.XyzTarget)
	e0:SetOperation(c43990117.XyzOperation)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e00:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e00:SetRange(LOCATION_EXTRA)
	e00:SetCode(EVENT_REMOVE)
	e00:SetCondition(c43990117.xyzcon)
	e00:SetOperation(c43990117.xyzop)
	c:RegisterEffect(e00)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(c43990117.atkcon)
	c:RegisterEffect(e1)
	--defense attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DEFENSE_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--rs
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(43990117,0))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,43990117)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c43990117.atkcon)
	e3:SetTarget(c43990117.rstg)
	e3:SetOperation(c43990117.rsop)
	c:RegisterEffect(e3)
	
end
function c43990117.xyzconfilter(c,tp)
	return c:IsSetCard(0x6510) and c:IsReason(REASON_EFFECT)
end
function c43990117.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c43990117.xyzconfilter,1,nil,tp) and (re and re:GetHandler():IsSetCard(0x6510))
end
function c43990117.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=nil
	local og=Duel.GetMatchingGroup(c43990117.Xyzfilter,tp,LOCATION_REMOVED,0,nil,c)
	c:RegisterFlagEffect(43990117,0,0,1,0)
	if not c:IsXyzSummonable(og,4,99) then return end
	if Duel.SelectYesNo(tp,aux.Stringid(43990117,2)) then
	c:ResetFlagEffect(43990117)
		c43990117.XyzTarget(e,tp,eg,ep,ev,re,r,rp,chk,c)
		c43990117.XyzOperation(e,tp,eg,ep,ev,re,r,rp,c)
		Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		c:CompleteProcedure()
	end
end
function c43990117.Xyzfilter(c,sc)
	return c:IsSetCard(0x6510) and c:IsFaceupEx() and c:IsCanBeXyzMaterial(sc) and c:IsXyzLevel(sc,4)
end
function c43990117.XyzCondition(e,tp,eg,ep,ev,re,r,rp,chk,c,og)
	local c=e:GetHandler()
	return not c:GetFlagEffect(43990117)
end
function c43990117.XyzTarget(e,tp,eg,ep,ev,re,r,rp,chk,c,og)
	local g=Group.CreateGroup()
	if og then 
		g=Duel.SelectXyzMaterial(tp,c,aux.FilterBoolFunction(Card.IsSetCard,0x6510),4,4,99,og)
	else
		local og=Duel.GetMatchingGroup(c43990117.Xyzfilter,tp,LOCATION_REMOVED,0,nil,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=og:Select(tp,4,99,nil)
	end
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c43990117.XyzOperation(e,tp,eg,ep,ev,re,r,rp,c,og)
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
		e1:SetDescription(aux.Stringid(43990117,3))
		e1:SetCategory(CATEGORY_REMOVE)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetTarget(c43990117.rmtg)
		e1:SetOperation(c43990117.rmop)
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
		e1:SetDescription(aux.Stringid(43990117,3))
		e1:SetCategory(CATEGORY_REMOVE)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetTarget(c43990117.rmtg)
		e1:SetOperation(c43990117.rmop)
		e1:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e1)
	end
end
function c43990117.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c43990117.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 and c:GetOriginalCode()==43990117 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c43990117.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c43990117.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c43990117.atkcon(e)
	return e:GetHandler():GetOverlayCount()==0
end
function c43990117.rsfilter(c,tc)
	return c:IsFaceup() and c:IsAbleToRemove() and c:IsSetCard(0x6510)
end
function c43990117.rstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and chkc:IsAbleToRemove() and chkc:IsSetCard(0x6510) end
	if chk==0 then return Duel.IsExistingTarget(c43990117.rsfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c43990117.rsfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,7,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function c43990117.spfilter(c,e,tp)
	return c:IsSetCard(0x6510) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c43990117.rsop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #tg==0 then return end
	if Duel.Remove(tg,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local ct=#(Duel.GetOperatedGroup())
		local og=Duel.GetOperatedGroup()
		local oc=og:GetFirst()
		while oc do
			oc:RegisterFlagEffect(43990117,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			oc=og:GetNext()
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(og)
		e1:SetOperation(c43990117.retop)
		Duel.RegisterEffect(e1,tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ct>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
		if ct>0 and ft>=ct and Duel.IsExistingMatchingCard(c43990117.spfilter,tp,LOCATION_DECK,0,ct,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(43990117,4)) then
				Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=Duel.SelectMatchingCard(tp,c43990117.spfilter,tp,LOCATION_DECK,0,ct,ct,nil,e,tp)
			Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end
function c43990117.retfilter(c)
	return c:GetFlagEffect(43990117)~=0
end
function c43990117.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c43990117.retfilter,nil)
	if sg:GetCount()>1 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)==1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		Duel.ReturnToField(tc)
	else
		local tc=sg:GetFirst()
		while tc do
			Duel.ReturnToField(tc)
			tc=sg:GetNext()
		end
	end
end
