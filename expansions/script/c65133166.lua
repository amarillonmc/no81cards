--幻叙 指令渲染
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if #g==0 then
		e:SetLabel(0)
		return
	end
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
	local sg=g:CancelableSelect(tp,1,63,nil)
	if sg then
		local att=0xff
		for tc in aux.Next(sg) do
			att=att&tc:GetAttribute()
		end
		e:SetLabel(sg:GetCount(),att)
		Duel.SendtoGrave(sg,REASON_COST+REASON_DISCARD)
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function s.filter(c)
	return c:IsSetCard(0x838) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct,att=e:GetLabel() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,0,2,fid)
		c:SetTurnCounter(2)
		--to hand
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(2,att,fid)
		e1:SetLabelObject(tc)
		e1:SetOperation(s.thop)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		c:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END,0,2)
		s[c]=e1
		for i=1,ct do
			local turne=c[c]
			if turne and c:GetFlagEffect(1082946)>0 then
				local op=turne:GetOperation()
				op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
			end
		end
	end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct,att,fid=e:GetLabel()
	ct=ct-1
	e:SetLabel(ct,att,fid)
	e:GetHandler():SetTurnCounter(ct)
	if ct==0 then
		e:GetOwner():ResetFlagEffect(1082946)
		local tc=e:GetLabelObject()
		if tc and tc:GetFlagEffectLabel(id)==fid then
			if tc:GetAttribute()&att>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and (Duel.SelectYesNo(tp,aux.Stringid(id,1)) and tc:IsAbleToHand()) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			end
		end
		e:Reset()
	end
end