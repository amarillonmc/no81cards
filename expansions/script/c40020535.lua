--空创重力
local s, id = GetID()
s.named_with_HighEvo = 1

function s.HighEvo(c)
	local m = _G["c" .. c:GetCode()]
	return m and m.named_with_HighEvo
end

function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.fuscon)
	e1:SetTarget(s.fustg)
	e1:SetOperation(s.fusop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_BATTLE_START)

	e2:SetTarget(s.locktg)
	e2:SetOperation(s.lockop)
	c:RegisterEffect(e2)
end

function s.fuscon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and (r&REASON_BATTLE+REASON_EFFECT)~=0
end

function s.fusfilter(c)
	return s.HighEvo(c) and c:IsType(TYPE_FUSION)
end


function s.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToGrave),tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD,0,nil)
end

function s.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then

		return Fusion.SummonEffTG(nil,e,tp,nil,nil,s.fusfilter,nil,s.fextra)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_FUSION_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.faceup_monster(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function s.fusop(e,tp,eg,ep,ev,re,r,rp)

	local fus_success = Fusion.SummonEffOP(nil,e,tp,nil,nil,s.fusfilter,nil,s.fextra)
	
	if fus_success then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(function(e,c) return not c:IsType(TYPE_FUSION) and c:IsLocation(LOCATION_EXTRA) end)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)

		if Duel.IsExistingMatchingCard(s.faceup_monster,tp,0,LOCATION_MZONE,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then 
			
			Duel.BreakEffect()
			s.do_lock_effect(e,tp)
		end
	end
end


function s.locktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.faceup_monster,tp,0,LOCATION_MZONE,1,nil) end
end

function s.lockop(e,tp,eg,ep,ev,re,r,rp)
	s.do_lock_effect(e,tp)
end


function s.do_lock_effect(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)

	local g=Duel.SelectMatchingCard(tp,s.faceup_monster,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
		e2:SetValue(1)
		tc:RegisterEffect(e2)
	end
end