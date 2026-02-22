--起死骸生的阵雨
local s,id,o=GetID()
--string
--s.named_with_Rebellion_Skull=1
s.named_with_Skullize=1
--SETCARD_REBELLION_SKULL =0xdce
--SETCARD_SKULLIZE =0xdce
--string check
function s.Rebellion_Skull(c)
	local m=_G["c"..c:GetCode()]
	return (m and m.named_with_Rebellion_Skull) or (SETCARD_REBELLION_SKULL and c:IsSetCard(SETCARD_REBELLION_SKULL))
end
function s.Skullize(c)
	local m=_G["c"..c:GetCode()]
	return (m and m.named_with_Skullize) or (SETCARD_SKULLIZE and c:IsSetCard(SETCARD_SKULLIZE))
end
--
function s.initial_effect(c)
	aux.AddCodeList(c,7435501,7435503)
	--Ritual Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.matfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsCanBeRitualMaterial(nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not Duel.IsPlayerCanSpecialSummonMonster(tp,7435551,0,TYPE_TOKEN+TYPE_MONSTER+TYPE_RITUAL+TYPE_EFFECT,2000,0,5,RACE_ZOMBIE,ATTRIBUTE_WIND,POS_FACEUP,tp,SUMMON_TYPE_RITUAL) then return false end
		local mg=Duel.GetRitualMaterial(tp)
		local mg=mg:Filter(s.matfilter,nil)
		local res=mg:CheckSubGroup(s.RitualCheck,1,nil,tp)
		--Debug.Message("0")
		return res
	end
	--Debug.Message("1")
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.RitualCheck(g,tp)
	if Duel.GetMZoneCount(tp,g,tp)<=0 then
		return false
	end
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetLevel,5)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	::cancel::
	--Debug.Message("2")
	local token=Duel.CreateToken(tp,7435551)
	local m=Duel.GetRitualMaterial(tp)
	local mg=m:Filter(s.matfilter,nil)
	if Duel.IsPlayerCanSpecialSummonMonster(tp,7435551,0,TYPE_TOKEN+TYPE_MONSTER+TYPE_RITUAL+TYPE_EFFECT,2000,0,5,RACE_ZOMBIE,ATTRIBUTE_WIND,POS_FACEUP,tp,SUMMON_TYPE_RITUAL) and mg:CheckSubGroup(s.RitualCheck,1,nil,tp) then
		--Debug.Message("3")
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg:SelectSubGroup(tp,s.RitualCheck,true,1,5,tp)
		if not mat then
			goto cancel
		end
		token:SetMaterial(mat)
		--Debug.Message("4")
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(token,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		token:CompleteProcedure()
		token:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
		--effect gain
		--atk
		local e1=Effect.CreateEffect(token)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(s.con)
		e1:SetValue(1000)
		token:RegisterEffect(e1)
		--indestructable
		local e2=Effect.CreateEffect(token)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCondition(s.indcon)
		e2:SetValue(1)
		token:RegisterEffect(e2)
		--destroy
		if not token then return end
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
		if mat:IsExists(s.mfilter,1,nil) and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=g:Select(tp,1,1,e:GetHandler())
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end
function s.mfilter(c)
	if c:IsPreviousLocation(LOCATION_MZONE) then
		local code,code2=c:GetPreviousCodeOnField()
		return code==7435501 or code2==7435501
	end
	return c:IsCode(7435501)
end
function s.con(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()==tp
end
function s.indfilter(c)
	return c:IsCode(7435503)
end
function s.indcon(e)
	return Duel.IsExistingMatchingCard(s.indfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
