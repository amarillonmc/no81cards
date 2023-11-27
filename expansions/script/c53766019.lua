if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	SNNM.Excavated_Check(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_PHASE+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_PHASE+TIMING_ATTACK+TIMING_END_PHASE)
	e3:SetCost(aux.bfgcost)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.ctfilter(c)
	return c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsCanAddCounter(0x153f,2)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and s.ctfilter(chkc) end
	if chk==0 then
		if e:GetHandler():GetFlagEffect(53766099)>0 then e:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE) else e:SetProperty(EFFECT_FLAG_CARD_TARGET) end
		return Duel.IsExistingTarget(s.ctfilter,tp,LOCATION_ONFIELD,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	local tc=Duel.SelectTarget(tp,s.ctfilter,tp,LOCATION_ONFIELD,0,1,1,nil):GetFirst()
	if tc:IsSetCard(0x5534) and e:GetHandler():IsStatus(STATUS_CHAINING) then
		local ret1,ret2={},{}
		local le={tc:IsHasEffect(EFFECT_IMMUNE_EFFECT)}
		for _,v in pairs(le) do
			local val=v:GetValue()
			table.insert(ret1,v)
			table.insert(ret2,val)
			v:SetValue(s.chval(val,e))
		end
		tc:AddCounter(0x153f,1)
		if tc:GetFlagEffect(53766000)==0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EFFECT_DESTROY_REPLACE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetTarget(s.reptg)
			e1:SetOperation(s.repop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			tc:RegisterFlagEffect(53766000,RESET_EVENT+RESETS_STANDARD,0,0)
		end
		for i=1,#ret1 do ret1[i]:SetValue(ret2[i]) end
	end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x153f)
end
function s.chval(_val,ce)
	return function(e,te,...)
				if te==ce then return false end
				return _val(e,te,...)
			end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x153f,2)
		if tc:GetFlagEffect(53766000)==0 and not tc:IsImmuneToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EFFECT_DESTROY_REPLACE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetTarget(s.reptg)
			e1:SetOperation(s.repop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			tc:RegisterFlagEffect(53766000,RESET_EVENT+RESETS_STANDARD,0,0)
		end
	end
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and c:IsCanRemoveCounter(tp,0x153f,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,0))
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0x153f,1,REASON_EFFECT)
end
function s.handcon(e)
	return e:GetHandler():GetFlagEffect(53766099)>0
end
function s.spfilter(c,e,tp)
	return c:IsAttack(0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_REVERSE_DAMAGE)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.valcon)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.valcon(e,re,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 then
		local tp=e:GetHandlerPlayer()
		local bc=rc:GetBattleTarget()
		if bc and bc:IsSetCard(0x5534) and bc:IsControler(tp)
			and Duel.GetFlagEffect(tp,id)==0 then
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
			return true
		end
	end
	return false
end

