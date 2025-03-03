--波动武士·微波防暴铳
local cm,m=GetID()
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--revive
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(cm.recost)
	e2:SetTarget(cm.retg)
	e2:SetOperation(cm.reop)
	c:RegisterEffect(e2)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local num=g:GetSum(Card.GetLevel)
	return Duel.GetMZoneCount(tp)>0 and (num%4)==0 and num~=0 and Duel.GetDecktopGroup(tp,2):FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==2
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetDecktopGroup(tp,2)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function cm.filter(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRace(RACE_PSYCHO) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_REMOVED,0,2,nil) end
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_REMOVED,0,2,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
	local g=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,LOCATION_REMOVED,0,2,2,nil)
	if #g>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)~=0 then
			local tg=Duel.GetOperatedGroup():Filter(aux.NecroValleyFilter(cm.filter),nil,e,tp)
			if #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				Duel.BreakEffect()
				if #tg==1 then
					tc=tg:GetFirst()
				else
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local sg=tg:Select(tp,1,1,nil)
					tc=sg:GetFirst()
				end
				Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
			end
		end
	end
end