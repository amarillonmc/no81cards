local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--to deck top
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.dtcon)
	e1:SetTarget(s.dttg)
	e1:SetOperation(s.dtop)
	c:RegisterEffect(e1)
	--banish and excavate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
end
function s.dtcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.dtfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function s.dttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.dtfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.dtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	local g=Duel.SelectMatchingCard(tp,s.dtfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,SEQ_DECKTOP)
		Duel.ConfirmDecktop(tp,1)
	end
end
function s.rmfilter(c,tp)
	return c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
	local dt=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if chk==0 then return ct>0 and dt>0 
		and Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA)
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.syncheck(g,tp)
	return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,g,g:GetCount()-1,g:GetCount()-1)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_EXTRA,0,nil,tp)
	local dt=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local max=math.min(ct,g:GetCount(),dt)
	if max==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:Select(tp,1,max,nil)
	if #rg>0 and Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local og=Duel.GetOperatedGroup()
		local fid=c:GetFieldID()
		local tc=og:GetFirst()
		while tc do
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			tc=og:GetNext()
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(og)
		e1:SetCondition(s.retcon)
		e1:SetOperation(s.retop)
		Duel.RegisterEffect(e1,tp)
		local ct=og:GetCount()
		Duel.ConfirmDecktop(tp,ct)
		local dg=Duel.GetDecktopGroup(tp,ct)
		local mg=dg:Filter(s.spfilter,nil,e,tp)
		local ft=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),4)
		if ft>0 and mg:GetCount()>0 and mg:CheckSubGroup(s.syncheck,1,ft,tp)
			and Duel.IsPlayerCanSpecialSummonCount(tp,2)
			and not Duel.IsPlayerAffectedByEffect(tp,59822133) 
			and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.DisableShuffleCheck()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=mg:SelectSubGroup(tp,s.syncheck,false,1,ft,tp)
			if sg:GetCount()>0 then
				local sc=sg:GetFirst()
				while sc do
					Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_DISABLE)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					sc:RegisterEffect(e2)
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_DISABLE_EFFECT)
					e3:SetValue(RESET_TURN_SET)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD)
					sc:RegisterEffect(e3)
					sc=sg:GetNext()
				end
				Duel.SpecialSummonComplete()
				local syng=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,sg,sg:GetCount()-1,sg:GetCount()-1)
				if syng:GetCount()>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local sync=syng:Select(tp,1,1,nil):GetFirst()
					Duel.SynchroSummon(tp,sync,nil,sg,sg:GetCount()-1,sg:GetCount()-1)
				end
			end
		end
	end
end
function s.retfilter(c,fid)
	return c:GetFlagEffectLabel(id)==fid
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(s.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	end
	return true
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(s.retfilter,nil,e:GetLabel())
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	g:DeleteGroup()
end