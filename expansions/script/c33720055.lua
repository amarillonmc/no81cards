-- 超美丽3D化 / Confine Sconcertante
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.tfilter(c,att,e,tp)
	return c:IsType(TYPE_MONSTER) and not c:IsRace(RACE_CYBERSE) and c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.filter(c,e,tp)
	if not c:IsSetCard(0x445,0x334c) then return false end
	local loc=c:IsSetCard(0x445) and LOCATION_HAND+LOCATION_DECK or LOCATION_HAND
	return c:IsFaceup() and Duel.GetMZoneCount(tp,c)>0 and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(s.tfilter,tp,loc,0,1,c,c:GetAttribute(),e,tp)
end
function s.chkfilter(c,att)
	return c:IsFaceup() and c:IsSetCard(0x8) and c:IsAttribute(att)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	if #g>0 then
		local tc=g:GetFirst()
		local att=tc:GetAttribute()
		local loc=tc:IsSetCard(0x445) and LOCATION_HAND+LOCATION_DECK or LOCATION_HAND
		if Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) then
			local atk,def=tc:GetTextAttack(),tc:GetTextDefense()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,s.tfilter,tp,loc,0,1,1,nil,att,e,tp)
			if #sg>0 then
				local sc=sg:GetFirst()
				Duel.BreakEffect()
				local skipchk=false
				if Duel.SpecialSummonStep(sc,0,tp,tp,true,false,POS_FACEUP) and (sc:GetBaseAttack()~=atk or sc:GetBaseDefense()~=def) then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					sc:RegisterEffect(e1,true)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					sc:RegisterEffect(e2,true)
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_SET_BASE_ATTACK)
					e3:SetValue(atk)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD)
					sc:RegisterEffect(e3,true)
					local e4=e3:Clone()
					e4:SetCode(EFFECT_SET_BASE_DEFENSE)
					e4:SetValue(def)
					sc:RegisterEffect(e4,true)
					skipchk=true
				end
				Duel.SpecialSummonComplete()
				if skipchk then
					Duel.BreakEffect()
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_FIELD)
					e2:SetCode(EFFECT_SKIP_BP)
					e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e2:SetTargetRange(1,0)
					if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()>PHASE_MAIN1 and Duel.GetCurrentPhase()<PHASE_MAIN2 then
						e2:SetLabel(Duel.GetTurnCount())
						e2:SetCondition(s.skipcon)
						e2:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
					else
						e2:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,1)
					end
					Duel.RegisterEffect(e2,tp)
				end
			end
		end
	end
end
function s.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end