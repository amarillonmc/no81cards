--幻叙救赎 光辉与荒诞之女
local s,id,o=GetID()
function s.initial_effect(c)
	-- Max 3 triggers
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(3,id)
	e1:SetCondition(s.tkcon)
	e1:SetTarget(s.tktg)
	e1:SetOperation(s.tkop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e2)
	-- Token stat buff
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.bufftg)
	e3:SetValue(s.buffval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
end
function s.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and not (c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_SPELLCASTER)) and (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_REMOVED))
end
function s.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg:Filter(s.cfilter,nil,tp)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0x838,TYPE_TOKEN+TYPE_MONSTER,0,0,8,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,1,1,nil)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.tkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		if not Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0x838,TYPE_TOKEN+TYPE_MONSTER,0,0,8,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) then return end
		
		local lv=tc:GetOriginalLevel()
		if lv==0 then lv=8 end
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		local def=tc:GetTextDefense()
		if def<0 then def=0 end
		local race=tc:GetOriginalRace()
		local att=tc:GetOriginalAttribute()
		
		local token=Duel.CreateToken(tp,id+1)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		
		-- Apply Stats
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(def)
		token:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(lv)
		token:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_ADD_RACE)
		e4:SetValue(race)
		token:RegisterEffect(e4)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_ADD_ATTRIBUTE)
		e5:SetValue(att)
		token:RegisterEffect(e5)
		
		Duel.SpecialSummonComplete()
	end
end
function s.bufftg(e,c)
	return c:IsCode(id+1)
end
function s.buffval(e,c)
	return e:GetHandler():GetDefense()/2
end