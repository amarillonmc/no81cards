--D-旅团 运输龙兽
local m=40011299
local cm=_G["c"..m]
cm.named_with_DBrigade=1
function cm.DBrigade(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_DBrigade
end
function cm.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg1)
	e1:SetOperation(cm.spop1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)  
	--attack twice
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e3:SetValue(1)
	c:RegisterEffect(e3) 
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
end
function cm.spfilter(c,e,tp)
	return cm.DBrigade(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=4 then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local ct=g:GetCount()
	if ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:FilterCount(cm.spfilter,nil,e,tp)>0
		and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:FilterSelect(tp,cm.spfilter,1,1,nil,e,tp)
		local tc=sg:GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
		ct=g:GetCount()-sg:GetCount()
		if ct>0 then
			if tc:GetLevel()<6 then
				g:Sub(sg)
				Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
			else
				local op=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))
				Duel.SortDecktop(tp,tp,ct)
				if op==0 then return end
				for i=1,ct do
					local mg=Duel.GetDecktopGroup(tp,1)
					Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
				end
			end
		end
	end

end
