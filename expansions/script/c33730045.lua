-- 键★高潮 冻土高原 / K.E.Y Climax - Plateau Congelato
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
s.water_aqua_key_monsters = true

function s.rvfilter(c)
	return not c:IsPublic() and c:IsSetCard(0x460) and c:IsType(TYPE_MONSTER)
end
function s.filter(c)
	return c:IsSetCard(0x460) and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_AQUA)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rvfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.rvfilter,tp,LOCATION_HAND,0,1,ct,nil)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ConfirmDecktop(tp,#g)
		local dg=Duel.GetDecktopGroup(tp,#g)
		local fg=dg:Filter(s.filter,nil)
		if #fg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			local opt
			if fg:IsExists(Card.IsAbleToGrave,1,nil) then
				opt=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
			else
				opt=Duel.SelectOption(tp,aux.Stringid(id,2))
			end
			if opt==0 then
				for tc in aux.Next(fg) do
					Duel.MoveSequence(tc,0)
				end
				Duel.SortDecktop(tp,tp,#fg)
				for i=1,#fg do
					local mg=Duel.GetDecktopGroup(tp,1)
					Duel.MoveSequence(mg:GetFirst(),1)
				end
				dg:Sub(fg)
			else
				local tg=fg:Filter(Card.IsAbleToGrave,nil)
				Duel.DisableShuffleCheck()
				Duel.SendtoGrave(tg,REASON_EFFECT+REASON_REVEAL)
				local chkg=tg:Filter(aux.NOT(Card.IsLocation),nil,LOCATION_DECK)
				if #chkg>0 then
					dg:Sub(chkg)
				end
			end
		end
		if #dg>0 then
			Duel.SortDecktop(tp,tp,#dg)
		end
	end
end

