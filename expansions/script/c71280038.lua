--异晶人的轮回
function c71280038.initial_effect(c)
	aux.AddCodeList(c,97403510)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,71280038)
	e1:SetTarget(c71280038.target)
	e1:SetOperation(c71280038.activate)
	c:RegisterEffect(e1)
	--act in deck
	local e2=e1:Clone()
	e2:SetRange(LOCATION_DECK)
	e2:SetCost(c71280038.cost)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetRange(LOCATION_DECK)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetLabelObject(e1)
	e3:SetTarget(c71280038.actarget)
	e3:SetOperation(c71280038.costop)
	c:RegisterEffect(e3)
	--set
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SSET)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetTarget(c71280038.settg)
	e6:SetOperation(c71280038.setop)
	c:RegisterEffect(e6)
end
function c71280038.filter1(c,e,tp)
	local rk=c:GetRank()
	return rk>0 and c:IsFaceup() and c:IsSetCard(0x48)
		and Duel.IsExistingMatchingCard(c71280038.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank(),c:GetRace(),c:GetAttribute(),c:GetCode())
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c71280038.filter2(c,e,tp,mc,rk,race,attr,code)
	if c:GetOriginalCode()==6165656 and not mc:IsCode(48995978) then return false end
	return c:IsSetCard(0x48) and c:IsRank(rk) and c:IsAttribute(attr) and c:IsRace(race) and mc:IsCanBeXyzMaterial(c) and not c:IsCode(code)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c71280038.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c71280038.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c71280038.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c71280038.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c71280038.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c71280038.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank(),tc:GetRace(),tc:GetAttribute(),tc:GetCode())
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
function c71280038.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerAffectedByEffect(tp,71280033) and Duel.GetFlagEffect(tp,71280033)==0 end
	Duel.RegisterFlagEffect(tp,71280033,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c71280038.actarget(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler()==e:GetHandler()
end
function c71280038.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	e:GetHandler():CreateEffectRelation(te)
	local c=e:GetHandler()
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
	e1:SetOperation(c71280038.rsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function c71280038.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
	end
end
function c71280038.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsSSetable() end
end
function c71280038.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 or not c:IsRelateToEffect(e) or not c:IsSSetable() then return end
	if Duel.SSet(tp,c)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(71280038,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		if Duel.IsExistingMatchingCard(c71280038.cfilter,tp,LOCATION_MZONE,0,1,nil)
			and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
			and Duel.IsExistingMatchingCard(c71280038.setfilter,tp,LOCATION_DECK,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(71280038,2)) then
			Duel.BreakEffect()
			local tc=Duel.SelectMatchingCard(tp,c71280038.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
			Duel.SSet(1-tp,tc)
		end
	end
end
function c71280038.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and (aux.IsCodeOrListed(c,97403510) or c:IsCode(23998625) or c:IsCode(47017574))
end
function c71280038.setfilter(c)
	return c:IsSetCard(0x176) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(false)
end