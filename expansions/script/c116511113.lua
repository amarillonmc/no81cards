function c116511113.initial_effect(c)
	c:SetSPSummonOnce(116511113)
	c:EnableReviveLimit()
	--special summon rule
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAINING)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetRange(LOCATION_EXTRA)
	e6:SetCondition(c116511113.chcon)
	e6:SetOperation(c116511113.chop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e7:SetRange(LOCATION_EXTRA)
	e7:SetCode(EVENT_BE_BATTLE_TARGET)
	e7:SetCondition(c116511113.atcon)
	e7:SetOperation(c116511113.atop)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_SPSUMMON_PROC)
	e8:SetRange(LOCATION_EXTRA)
	e8:SetCondition(c116511113.xyzcon)
	e8:SetOperation(c116511113.xyzop)
	e8:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e8)
	--spsummon condition
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EFFECT_SPSUMMON_CONDITION)
	e9:SetValue(c116511113.splimit)
	c:RegisterEffect(e9)
	--act limit
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_SPSUMMON)
	e10:SetOperation(c116511113.limop)
	c:RegisterEffect(e10)
	--【ここまでX召喚ルール】
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetCondition(c116511113.imcon)
	e3:SetValue(c116511113.efilter)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetDescription(aux.Stringid(116511113,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c116511113.cost)
	e4:SetTarget(c116511113.sumtg)
	e4:SetOperation(c116511113.sumop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetDescription(aux.Stringid(116511113,0))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetHintTiming(0,TIMING_END_PHASE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c116511113.cost)
	e5:SetTarget(c116511113.sptg)
	e5:SetOperation(c116511113.spop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_TRIGGER)
	e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetTarget(c116511113.distg)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(1,1)
	e7:SetTarget(c116511113.sumlimit)
	c:RegisterEffect(e7)
end
--【召喚ルール】
function c116511113.cfilter(c,xyzc,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x108a) and not c:IsType(TYPE_XYZ)
		and c:IsCanBeXyzMaterial(xyzc) and c:IsFaceup()
end
function c116511113.chcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c116511113.cfilter,1,nil,c,tp) and Duel.IsChainNegatable(ev) and re:GetHandler():IsRelateToEffect(re)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c116511113.xyzfilter(c,e,tp,xyzc)
	return not c:IsType(TYPE_TOKEN) and (c:IsCanBeXyzMaterial(xyzc) or not c:IsType(TYPE_MONSTER))
end
function c116511113.xyzfilter2(c,e,tp)
	return not c:IsType(TYPE_TOKEN)
end
function c116511113.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(c116511113.xyzfilter,nil,e,tp,c)
	local g2=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(c116511113.xyzfilter2,nil,e,tp)
	if Duel.GetFlagEffect(tp,116511113)==0 and g:GetCount()>0 and g:GetCount()==g2:GetCount() and rc:IsRelateToEffect(re)
		and Duel.IsChainNegatable(ev) and Duel.GetLocationCountFromEx(tp,tp,g,c)>0 and Duel.SelectYesNo(tp,aux.Stringid(116511113,3)) then
		Duel.ConfirmCards(1-tp,c)
		Duel.RegisterFlagEffect(tp,116511113,RESET_PHASE+PHASE_END,0,1)
		if Duel.NegateEffect(ev) then
			rc:CancelToGrave()
			g:AddCard(rc)
			local tc=g:GetFirst()
			while tc do
				local og=tc:GetOverlayGroup()
				if og:GetCount()>0 then
					Duel.SendtoGrave(og,REASON_RULE)
				end
				tc:RegisterFlagEffect(116511113,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
				tc=g:GetNext()
			end
			Duel.XyzSummon(tp,c,nil)
		end
	end
end

function c116511113.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsFaceup() and tc:IsSetCard(0x108a) and not tc:IsType(TYPE_TOKEN) and not tc:IsType(TYPE_XYZ)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c116511113.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not (Duel.GetLocationCountFromEx(tp,tp,a,c)>0 or Duel.GetLocationCountFromEx(tp,tp,d,c)>0) then return end
	if not a:IsRelateToEffect(e) and a:IsAttackable() and not a:IsStatus(STATUS_ATTACK_CANCELED)
		and a:IsCanBeXyzMaterial(c) and d:IsCanBeXyzMaterial(c)
		and not d:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(116511113,3)) then
		Duel.ConfirmCards(1-tp,c)
		if Duel.NegateAttack() then
			local g=Group.FromCards(a,d)
			local tc=g:GetFirst()
			while tc do
				local og=tc:GetOverlayGroup()
				if og:GetCount()>0 then
					Duel.SendtoGrave(og,REASON_RULE)
				end
				tc:RegisterFlagEffect(116511113,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
				tc=g:GetNext()
			end
			Duel.XyzSummon(tp,c,nil)
		end
	end
end

function c116511113.mfilter(c,xyzc)
	return c:GetFlagEffect(116511113)~=0 and (c:IsCanBeXyzMaterial(xyzc) or not c:IsType(TYPE_MONSTER))
end
function c116511113.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=nil
	if og then
		mg=og:Filter(c116511113.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c116511113.mfilter,tp,0xff,0xff,nil,c)
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and mg:GetCount()>0
end
function c116511113.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local c=e:GetHandler()
	local g=nil
	local sg=Group.CreateGroup()
	local xyzg=Group.CreateGroup()
	if og then
		g=og
		local tc=og:GetFirst()
	else
		local mg=nil
		if og then
			mg=og:Filter(c116511113.mfilter,nil,c)
		else
			mg=Duel.GetMatchingGroup(c116511113.mfilter,tp,0xff,0xff,nil,c)
		end
		local ct=mg:GetCount()
		xyzg:Merge(mg)
	end
	c:SetMaterial(xyzg)
	Duel.Overlay(c,xyzg)
end

function c116511113.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or (bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and se:GetHandler():IsCode(116511113))
end

function c116511113.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then return end
	Duel.SetChainLimitTillChainEnd(c116511113.chlimit)
end
function c116511113.chlimit(e,rp,tp)
	return e:IsActiveType(TYPE_TRAP) and e:GetHandler():IsType(TYPE_COUNTER)
end

function c116511113.imcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c116511113.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function c116511113.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c116511113.sumfilter(c)
	return c:IsSetCard(0x108a) and c:IsSummonable(true,nil)
end
function c116511113.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c116511113.sumfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c116511113.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c116511113.sumfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
function c116511113.spfilter(c,e,tp)
	return c:IsSetCard(0x108a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c116511113.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c116511113.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c116511113.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c116511113.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c116511113.distg(e,c)
	return not c:IsSetCard(0x108a)
end
function c116511113.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x108a)
end
