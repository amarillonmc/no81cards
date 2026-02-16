--Card ID: [Your Card ID]
--Scripted by Gem
local s,id,o=GetID()
function s.initial_effect(c)
	--Synchro Summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	
	--Effect 1: Summon Limit (Cannot summon if same name exists)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetTarget(s.sumlimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e2)

	--Effect 2: Token Generation
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMING_MAIN_END)
	e4:SetCountLimit(1)
	e4:SetCondition(s.tkcon)
	e4:SetTarget(s.tktg)
	e4:SetOperation(s.tkop)
	c:RegisterEffect(e4)
end

--Logic for Effect 1
function s.filter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	--Check if a face-up monster with the same code already exists on the field (either side)
	return Duel.IsExistingMatchingCard(s.filter,sump,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetCode())
end

--Logic for Effect 2
function s.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 
		and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN_MONSTER,0,2500,1,RACE_WARRIOR,ATTRIBUTE_EARTH)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function s.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,g)
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local sg=g:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_MONSTER)
	local tc=sg:GetFirst()
	
	if tc then
		--Choose which field to summon to
		local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		local p=tp
		if b1 and b2 then
			p=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))==0 and tp or 1-tp
		elseif b1 then
			p=tp
		elseif b2 then
			p=1-tp
		else
			return --No zones available
		end
		
		--Create Token
		local token=Duel.CreateToken(tp,id+1) --Assuming id+1 is the Token ID
		
		--Set Token Stats based on selected monster
		local code=tc:GetOriginalCode()
		local race=tc:GetOriginalRace()
		local att=tc:GetOriginalAttribute()
		local atk=tc:GetTextAttack()
		
		Duel.SpecialSummonStep(token,0,tp,p,false,false,POS_FACEUP)
		
		--Apply Stats
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
		
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CHANGE_RACE)
		e4:SetValue(race)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e4)
		
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e5:SetValue(att)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e5)
		
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_CHANGE_CODE)
		e6:SetValue(code)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e6)

		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_CANNOT_ATTACK)
		e7:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		token:RegisterEffect(e7)
		
		Duel.SpecialSummonComplete()
	end
	Duel.ShuffleExtra(1-tp)
end