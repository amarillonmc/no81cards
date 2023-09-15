--螺旋变升 蓝莓
function c88100105.initial_effect(c)
	aux.AddXyzProcedureLevelFree(c,c88100105.mfilter,nil,3,3)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c88100105.valcheck)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88100105,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,88100105)
	e2:SetCondition(c88100105.drcon)
	e2:SetTarget(c88100105.drtg)
	e2:SetOperation(c88100105.drop)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88100105,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMING_END_PHASE+TIMING_TOGRAVE)
	e3:SetCountLimit(1,88200105)
	e3:SetTarget(c88100105.target)
	e3:SetOperation(c88100105.operation)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(88100105,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCountLimit(1,88300105)
	e4:SetCondition(c88100105.spcon)
	e4:SetTarget(c88100105.sptg)
	e4:SetOperation(c88100105.spop)
	c:RegisterEffect(e4)
end
function c88100105.mfilter(c,xyzc)
	return c:IsRank(3)
end
function c88100105.valcheck(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local flag=0
	if c:GetMaterial():FilterCount(Card.IsAttribute,nil,ATTRIBUTE_DARK)>0 then flag=flag+1 end
	if c:GetMaterial():FilterCount(Card.IsAttribute,nil,ATTRIBUTE_DEVINE)>0 then flag=flag+1 end
	if c:GetMaterial():FilterCount(Card.IsAttribute,nil,ATTRIBUTE_EARTH)>0 then flag=flag+1 end
	if c:GetMaterial():FilterCount(Card.IsAttribute,nil,ATTRIBUTE_FIRE)>0 then flag=flag+1 end
	if c:GetMaterial():FilterCount(Card.IsAttribute,nil,ATTRIBUTE_LIGHT)>0 then flag=flag+1 end
	if c:GetMaterial():FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WATER)>0 then flag=flag+1 end
	if c:GetMaterial():FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WIND)>0 then flag=flag+1 end
	e:GetLabelObject():SetLabel(flag)
end
function c88100105.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c88100105.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dr=e:GetLabel()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,dr) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(dr)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,dr)
end
function c88100105.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local turnp=Duel.GetTurnPlayer()
	Duel.SkipPhase(turnp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(turnp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,turnp)
end
function c88100105.filter(c)
	return c:IsCanOverlay()
end
function c88100105.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and c88100105.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c88100105.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,c88100105.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	if Duel.GetCurrentPhase()==PHASE_STANDBY or Duel.GetCurrentPhase()==PHASE_END then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function c88100105.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(c,Group.FromCards(tc))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetTarget(c88100105.distg)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c88100105.discon)
		e2:SetOperation(c88100105.disop)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		if (Duel.GetCurrentPhase()==PHASE_STANDBY or Duel.GetCurrentPhase()==PHASE_END) and Duel.SelectYesNo(tp,aux.Stringid(88100105,3)) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c88100105.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c88100105.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c88100105.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c88100105.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>4
end
function c88100105.spfilter(c,e,tp)
	return c:IsRace(RACE_PLANT) and c:IsRankAbove(10) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsCode(88100107) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c88100105.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88100105.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c88100105.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c88100105.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	local sp=0
	if tc and tc:GetCode()==88100107 then
		if Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)~=0 then
			sp=1
		end
	elseif tc then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		   sp=1
		end
	end
	if sp==1 and c:IsRelateToEffect(e) then
		local mg=c:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(tc,mg)
		end
		Duel.Overlay(tc,Group.FromCards(c))
	end
end