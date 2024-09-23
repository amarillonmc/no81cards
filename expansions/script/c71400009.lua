--异梦画廊的假面画师
if not c71400001 then dofile("expansions/script/c71400001.lua") end
function c71400009.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,yume.YumeCheck(c,true),4,2)
	--summon limit
	yume.AddYumeSummonLimit(c,1)
	--cannot special summon
	local elim=Effect.CreateEffect(c)
	elim:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	elim:SetType(EFFECT_TYPE_SINGLE)
	elim:SetRange(LOCATION_GRAVE)
	elim:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(elim)
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400009,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,71400009)
	e1:SetTarget(c71400009.tg1)
	e1:SetOperation(c71400009.op1)
	c:RegisterEffect(e1)
	--place field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400009,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,71500009)
	e2:SetTarget(c71400009.tg2)
	e2:SetOperation(c71400009.op2)
	c:RegisterEffect(e2)
	--overlay
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71400009,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,71510009)
	e3:SetTarget(c71400009.tg3)
	e3:SetOperation(c71400009.op3)
	c:RegisterEffect(e3)
end
function c71400009.filter1(c)
	return c:IsSetCard(0xb714) and c:IsType(TYPE_FIELD) and c:IsCanOverlay()
end
function c71400009.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c71400009.filter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c71400009.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71400009.filter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(c,g)
		end
	end
end
function c71400009.filter2(c,tp)
	return c:IsSetCard(0xb714) and c:IsType(TYPE_FIELD) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c71400009.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetOverlayGroup(tp,1,0)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT) and g:IsExists(c71400009.filter2,1,nil,tp) end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
end
function c71400009.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetOverlayGroup(tp,1,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local g1=g:FilterSelect(tp,c71400009.filter2,1,1,nil,tp)
	if g1:GetCount()>0 and Duel.SendtoGrave(g1,REASON_EFFECT)>0 then 
		Duel.RaiseSingleEvent(e:GetHandler(),EVENT_DETACH_MATERIAL,e,0,0,0,0)
		local tc=Duel.GetOperatedGroup():GetFirst()
		if (tc:IsFaceup() and tc:IsLocation(LOCATION_REMOVED) or tc:IsLocation(LOCATION_GRAVE)) and aux.NecroValleyFilter()(tc) then
			local te=tc:GetActivateEffect()
			if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
			local b=te:IsActivatable(tp,true,true)
			Duel.ResetFlagEffect(tp,15248873)
			if b and Duel.SelectYesNo(tp,aux.Stringid(71400009,3)) then
				local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
				if fc then
					Duel.SendtoGrave(fc,REASON_RULE)
					Duel.BreakEffect()
				end
				Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
				te:UseCountLimit(tp,1,true)
				local tep=tc:GetControler()
				local cost=te:GetCost()
				if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
				Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
			end
		end
	end
end
function c71400009.filter3(c)
	return c:IsFaceup() and c:IsSetCard(0x714) and c:IsType(TYPE_XYZ)
end
function c71400009.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c71400009.filter3(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c71400009.filter3,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and e:GetHandler():IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c71400009.filter3,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c71400009.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end