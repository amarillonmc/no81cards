--六花圣 华绽之大山茶花
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddXyzProcedureLevelFree(c,s.mfilter,nil,2,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.discon)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(s.cost)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
function s.mfilter(c,xyzc)
	return c:IsRace(RACE_PLANT) and (c:IsXyzLevel(xyzc,10) or c:IsType(TYPE_XYZ))
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and Duel.IsChainDisablable(ev)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev)~=0 then 
		local og=e:GetHandler():GetOverlayGroup()
		if og:GetCount()==0 then return end
		if Duel.SendtoGrave(og,REASON_EFFECT+REASON_RELEASE)>=2 then
		   local sg=Duel.GetOperatedGroup()
		   if sg:GetClassCount(Card.GetOriginalRace,RACE_PLANT)==1 and (sg:FilterCount(Card.IsType,nil,TYPE_XYZ)>0 or (sg:GetClassCount(Card.GetLevel)==1 and sg:GetClassCount(Card.GetCode)~=1)) and Duel.IsExistingMatchingCard(Card.IsReleasableByEffect,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local rg=Duel.SelectMatchingCard(tp,Card.IsReleasableByEffect,tp,0,LOCATION_ONFIELD,1,1,nil)
				local tc=rg:GetFirst()
				if tc then
					Duel.HintSelection(rg)
					Duel.Release(rg,REASON_EFFECT)
				end
			end
		end
	end
end
function s.costfilter(c,tp)
	return (c:IsControler(tp) or c:IsFaceupEx()) and (c:IsRace(RACE_PLANT) or c:IsHasEffect(76869711,tp) and c:IsControler(1-tp))
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x141) 
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,s.costfilter,1,REASON_COST,true,nil,tp) end
	local g=Duel.SelectReleaseGroupEx(tp,s.costfilter,1,1,REASON_COST,true,nil,tp)
	Duel.Release(g,REASON_COST)
	local tc=Duel.GetOperatedGroup():GetFirst()
	e:SetLabelObject(tc)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	if tc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(s.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		if e:GetLabelObject():IsType(TYPE_XYZ) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function s.efilter(e,te)
	if te:GetOwnerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler())
end