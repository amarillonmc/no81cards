--星遗物的觉醒 夏娃
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,s.matfilter,1,1) 
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_SZONE+LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(s.tgtg)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)   
	--link sm
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.con)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end

function s.matfilter(c)
	return c:IsLinkRace(RACE_CYBERSE) and c:IsLinkType(TYPE_LINK)
end

--e1
function s.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function s.val(e,c)
	return c:GetLink()*500
end

--e2
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,1-tp,id)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(s.lkfilter,tp,LOCATION_EXTRA,0,nil)
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(TYPE_CONTINUOUS+TYPE_SPELL)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetRange(LOCATION_SZONE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_LINK_SPELL_KOISHI)
		e2:SetValue(LINK_MARKER_TOP)
		c:RegisterEffect(e2)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.LinkSummon(tp,sg:GetFirst(),nil)
		end
	end
end
function s.lkfilter(c)
	return c:IsRace(RACE_CYBERSE) and c:IsLinkSummonable(nil)
end