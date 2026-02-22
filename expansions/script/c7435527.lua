--起死骸生的暴风
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
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
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
		if not Duel.IsPlayerCanSpecialSummonMonster(tp,7435553,0,TYPE_TOKEN+TYPE_MONSTER+TYPE_RITUAL+TYPE_EFFECT,1200,0,3,RACE_ZOMBIE,ATTRIBUTE_WIND,POS_FACEUP,tp,SUMMON_TYPE_RITUAL) then return false end
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
	return g:CheckWithSumGreater(Card.GetLevel,3)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	::cancel::
	--Debug.Message("2")
	local token=Duel.CreateToken(tp,7435553)
	local m=Duel.GetRitualMaterial(tp)
	local mg=m:Filter(s.matfilter,nil)
	if Duel.IsPlayerCanSpecialSummonMonster(tp,7435553,0,TYPE_TOKEN+TYPE_MONSTER+TYPE_RITUAL+TYPE_EFFECT,1200,0,3,RACE_ZOMBIE,ATTRIBUTE_WIND,POS_FACEUP,tp,SUMMON_TYPE_RITUAL) and mg:CheckSubGroup(s.RitualCheck,1,nil,tp) then
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
		--damage
		local e1=Effect.CreateEffect(token)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BATTLE_DESTROYING)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(s.damcon)
		e1:SetOperation(s.damop)
		token:RegisterEffect(e1)
		--indestructable
		local e2=Effect.CreateEffect(token)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCondition(s.indcon)
		e2:SetValue(1)
		token:RegisterEffect(e2)
		--destroy
		if not token then return end
		if mat:IsExists(s.mfilter,1,nil) and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function s.mfilter(c)
	if c:IsPreviousLocation(LOCATION_MZONE) then
		local code,code2=c:GetPreviousCodeOnField()
		return code==7435503 or code2==7435503
	end
	return c:IsCode(7435503)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local bc=tc:GetBattleTarget()
	return tc:IsFaceup() and tc:IsRace(RACE_ZOMBIE) and tc:IsRelateToBattle() and bc and bc:IsPreviousControler(1-tp)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local bc=tc:GetBattleTarget()
	if not bc then return end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	if g:GetCount()==0 then return end
	local mg,lv=g:GetMaxGroup(Card.GetLevel)
	if lv==0 then return end
	local dam=math.max(lv*200,0)
	if dam>0 then
		Duel.Hint(HINT_CARD,0,7435553)
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end
function s.indfilter(c)
	return c:IsCode(7435501)
end
function s.indcon(e)
	return Duel.IsExistingMatchingCard(s.indfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
