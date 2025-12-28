--星海航线 奥菲莉娅
local m=11560721
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	c:EnableCounterPermit(0x1810)
	aux.AddXyzProcedureLevelFree(c,c11560721.mfilter,c11560721.xyzcheck,3,3)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c11560721.atkdefval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e2)
	--不会成为效果的对象
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE+LOCATION_PZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--atl2
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_MZONE+LOCATION_PZONE)
	e4:SetCondition(c11560721.atkdamcon)
	e4:SetOperation(c11560721.atkdamop)
	c:RegisterEffect(e4)
	--neg
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_MZONE+LOCATION_PZONE)
	e5:SetCondition(c11560721.negcon)
	e5:SetOperation(c11560721.negop)
	c:RegisterEffect(e5)
	--rec
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetRange(LOCATION_MZONE+LOCATION_PZONE)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(c11560721.reccon)
	e6:SetOperation(c11560721.recop)
	c:RegisterEffect(e6)
	--dis
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_LEAVE_FIELD)
	e7:SetRange(LOCATION_MZONE)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCondition(c11560721.leavecon)
	e7:SetOperation(c11560721.leaveop)
	c:RegisterEffect(e7)
	--adjust
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e8:SetCode(EVENT_ADJUST)
	e8:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e8:SetRange(LOCATION_ONFIELD)
	e8:SetOperation(c11560721.adjustop)
	c:RegisterEffect(e8)

	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_TOGRAVE)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e9:SetCode(EVENT_CUSTOM+11560721)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(c11560721.mzpcon)
	e9:SetTarget(c11560721.mzptg)
	e9:SetOperation(c11560721.mzpop)
	c:RegisterEffect(e9)

	local e10=Effect.CreateEffect(c)
	e10:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e10:SetCode(EVENT_CUSTOM+11560721)
	e10:SetRange(LOCATION_PZONE)
	e10:SetCondition(c11560721.pscon)
	e10:SetTarget(c11560721.pstg)
	e10:SetOperation(c11560721.psop)
	c:RegisterEffect(e10)
end
function c11560721.mfilter(c,xyzc)
	return c:IsLevelAbove(1) and c:IsRace(RACE_MACHINE)
end
function c11560721.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==1
end
function c11560721.atkdefval(e,c)
	return c:GetCounter(0x1810)*300
end
function c11560721.atkdamcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return a and a:IsControler(tp) and a:IsRace(RACE_MACHINE)
end
function c11560721.atkdamop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(11560721,0)) then
		c:AddCounter(0x1810,1)
		Duel.Damage(1-tp,1000,REASON_EFFECT)
		local a=Duel.GetAttacker()
		if a:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(math.floor(a:GetBaseAttack())/2)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			a:RegisterEffect(e1)
		end
	end
end
function c11560721.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not tg then return false end
	return tg:IsExists(c11560721.negfilter,1,nil,tp)
end
function c11560721.negfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsRace(RACE_MACHINE) and c:IsOnField()
end
function c11560721.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(11560721,1)) then
		c:AddCounter(0x1810,1)
		Duel.NegateEffect(ev)
	end
end
function c11560721.recfilter(c,tp)
	if not (c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsType(TYPE_MONSTER)) then return false end
	local rc=c:GetReasonCard()
	return rc and rc:IsRace(RACE_MACHINE) and rc:GetPreviousControler()==tp
end
function c11560721.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11560721.recfilter,1,nil,tp)
end
function c11560721.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(11560721,2)) then
		c:AddCounter(0x1810,1)
		local g=eg:Filter(c11560721.recfilter,nil,tp)
		local total_atk=0
		local tc=g:GetFirst()
		while tc do
			total_atk=total_atk+tc:GetBaseAttack()
			tc=g:GetNext()
		end
		if total_atk>0 then
			Duel.Recover(tp,math.floor(total_atk/2),REASON_EFFECT)
		end
	end
end
function c11560721.leavefilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp) and c:IsRace(RACE_MACHINE) and c:GetReasonPlayer()==1-tp
end
function c11560721.leavecon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11560721.leavefilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil)
end
function c11560721.leaveop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(11560721,3)) then
		c:AddCounter(0x1810,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local sg=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil,tp)
		if sg:GetCount()>0 then
		local tc=sg:GetFirst()
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetValue(RESET_TURN_SET)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			end
		end
	end
end
function c11560721.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	if c:GetCounter(0x1810)>4 and not c:GetFlagEffectLabel(11560721) then
		c:RegisterFlagEffect(11560721,RESET_EVENT+0xff0000+RESET_CHAIN,0,1,1)
		Duel.RaiseEvent(c,EVENT_CUSTOM+11560721,e,0,0,0,0)
	end
end
function c11560721.mzpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and c:GetCounter(0x1810)>4
end
function c11560721.mzptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_FIELD,e:GetHandler(),1,0,0)
end
function c11560721.mzpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local o_count=c:GetOverlayCount()
	if Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
		if o_count>0 and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(11560721,5)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0,o_count,nil)
			if #g>0 then
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
	end
end
function c11560721.pscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not eg:IsContains(c) then return false end
	return c:GetCounter(0x1810)>4 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11560721.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11560721.matfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsCanOverlay()
end
function c11560721.gmafilter(c,e)
	return not c:IsImmuneToEffect(e)
end
function c11560721.psop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(c11560721.matfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local sg=g:Select(tp,0,3,nil)
			local og=sg:Filter(c11560721.gmafilter,nil,e)
			local count=#og
			if count>0 then
				Duel.Overlay(c,og)
				Duel.Recover(tp,count*300,REASON_EFFECT)
			end
		end
	end
end
