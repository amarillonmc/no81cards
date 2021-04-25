--Falling Light
local m=33701416
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	
end
function cm.filter(c)
	return c:GetLevel()>0 and c:IsAbleToRemove()
end
function cm.filter1(c)
	return c:IsType(TYPE_TUNER)
end
function cm.filter2(c)
	return not c:IsType(TYPE_TUNER)
end
function cm.exfilter(c,g,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsLevel(g:GetSum(Card.GetLevel())) and c:IsLevelAbove(10) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.exfilter1(c,lv,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsLevel(lv) and c:IsLevelAbove(10) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.fselect(g,e,tp)
	return g:IsExists(cm.filter1,1,nil) and g:IsExists(cm.filter2,1,nil) and Duel.IsExistingMatchingCard(cm.exfilter,tp,LOCATION_EXTRA,0,1,nil,g,e,tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return g:CheckSubGroup(cm.fselect,2,2,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and g:CheckSubGroup(cm.fselect,2,2,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=g:SelectSubGroup(tp,cm.fselect,false,2,2)
		local lv=rg:GetSum(Card.GetLevel)
		if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,cm.exfilter1,tp,LOCATION_EXTRA,0,1,1,nil,lv,e,tp)
			local sc=sg:GetFirst()
			if sc and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)>0 then
				local op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
				if op=0 then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e1:SetCode(EFFECT_SKIP_TURN)
					e1:SetTargetRange(1,0)
					e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
					Duel.RegisterEffect(e1,tp)
				else
					local dmg=sc:GetLevel()*800
					if Duel.GetLP(tp)<dmg then
						Duel.SetLP(tp,10)
					else
						Duel.Damage(tp,sc:GetLevel()*800,REASON_EFFECT)
					end
				end
			end
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabelObject(e)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return se~=e:GetLabelObject()
end
