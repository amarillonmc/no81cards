--天人 阿雷路亚·哈普提森
local s,id=GetID()
--CB
s.named_with_CelestialBeing=1
function s.CelestialBeing(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_CelestialBeing
end
function s.initial_effect(c)
	aux.EnableUnionAttribute(c,s.filter)
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)

	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_EQUIP)
	e8:SetCode(EFFECT_DIRECT_ATTACK)
	e8:SetCondition(s.dircon)
	c:RegisterEffect(e8)

end
s.has_text_type=TYPE_UNION
function s.filter(c)
	return (c:IsRace(RACE_MACHINE) and s.CelestialBeing(c) and c:IsLevelAbove(3)) 
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end

function s.spfilter(c,e,tp)
	return c:IsLevelBelow(5) and c:IsRace(RACE_MACHINE) and s.CelestialBeing(c) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,2,REASON_EFFECT)==2 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD,nil)>0 then
			Duel.BreakEffect()
			local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
			if #g>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,1,1,nil)
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			else
				local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
				if #hg>0 then
					Duel.SendtoGrave(hg,REASON_EFFECT)
				end
			end
		end
	end
end
function s.dirfilter(c)
	return c:IsFaceup() and c:IsLevelBelow(5)
end

function s.dircon(e)
	local ec=e:GetHandler():GetEquipTarget()
	if not ec then return false end
	return not Duel.IsExistingMatchingCard(s.dirfilter, ec:GetControler(), 0, LOCATION_MZONE, 1, nil)
end