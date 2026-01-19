--鸟兽气兵 麒麟儿
local s, id = GetID()
s.named_with_ForceFighter=1
function s.ForceFighter(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ForceFighter
end
function s.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_MACHINE),2,2)	

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.drcon)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCondition(s.costcon)
	e2:SetCost(s.costchk)
	e2:SetOperation(s.actop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_FLAG_EFFECT+id)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	c:RegisterEffect(e3)
end


function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsSummonType(SUMMON_TYPE_LINK) then return false end
	local mg=c:GetMaterial()
	return mg:GetCount()>0 and not mg:IsExists(aux.NOT(s.ForceFighter),1,nil)
end

function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end

function s.spfilter(c,e,tp)
	return s.ForceFighter(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)

	if Duel.Draw(tp,2,REASON_EFFECT)==2 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		
		local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
		local sp_success=false
		

		if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			if sg:GetCount()>0 then
				if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)>0 then
					sp_success=true
				end
			end
		end
		

		if not sp_success then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,2,2,nil)
			if rg:GetCount()>0 then
				Duel.SendtoDeck(rg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
			end
		end
	end
end
function s.costcon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end

function s.costchk(e,te_or_c,tp)

	return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,3,nil)
end

function s.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,3,3,nil)
	if g:GetCount()==3 then
		Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_COST)
	end
end
