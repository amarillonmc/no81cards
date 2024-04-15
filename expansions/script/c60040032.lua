--瞬逝的幸福
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	--avoid damage
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e4:SetCode(EFFECT_CHANGE_DAMAGE)
			e4:SetTargetRange(1,0)
			e4:SetValue(cm.damval)
			e4:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e4,tp)
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
			e4:SetTargetRange(1,0)
			e4:SetValue(cm.damval)
			e4:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e4,tp)
	Duel.BreakEffect()
	local dg=Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_ONFIELD,0,nil,RACE_MACHINE)
	if #dg>=4 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		if Duel.Destroy(dg,REASON_EFFECT) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_DECK,0,1,nil) then
			local num=#Duel.GetOperatedGroup()
			local sg=Group.CreateGroup()
			local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_DECK,0,nil)
			local dc=dg:GetFirst()
			local i=1
			while dc and #sg<num do
				if dc:IsSpecialSummonable() and dc:IsRace(RACE_MACHINE) then
					sg:AddCard(dc)
				end
				i=i+1
				dc=dg:GetNext()
			end
			Duel.ConfirmDecktop(tp,i-1)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)>=3000 then return 3000 end
	return val
end