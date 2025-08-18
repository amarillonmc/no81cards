--逆熵科技 鸟型闹钟
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,75646600)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--The Key
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(s.keyop)
	c:RegisterEffect(e2)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.tgfilter(c)
	return aux.IsCodeListed(c,75646600) and c:IsAbleToGrave()
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
			Duel.BreakEffect()
			local b2=Duel.GetFlagEffect(tp,75646600)~=0 and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil)
			local op=aux.SelectFromOptions(tp,
				{true,aux.Stringid(id,2)},
				{b2,aux.Stringid(id,3)},
				{true,aux.Stringid(id,4)})
			if op==1 then
				local rg=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,0x7f,0,nil,75646600)
				if rg:GetCount()>0 then
					local rc=rg:GetFirst()
					while rc do
						if rc:GetFlagEffect(5646600)<15 then
							rc:RegisterFlagEffect(5646600,0,0,0)
						end
						rc:ResetFlagEffect(646600)
						rc:RegisterFlagEffect(646600,0,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(75646600,rc:GetFlagEffect(5646600)))	
						rc=rg:GetNext()
					end
				end
			elseif op==2 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
				if g:GetCount()>0 then
					Duel.SendtoGrave(g,REASON_EFFECT)
				end
			end
		end
	end
end
function s.keyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,id)<1 and Duel.SelectYesNo(tp,aux.Stringid(75646601,3)) then
		Duel.Hint(HINT_CARD,0,id)
		Duel.RegisterFlagEffect(tp,75646600,RESET_EVENT+RESET_PHASE+RESET_CHAIN,0,1)
		Duel.RegisterFlagEffect(tp,id,RESET_EVENT+RESET_PHASE+PHASE_END,0,1)
		local rg=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,0x7f,0,nil,75646600)
		if rg:GetCount()>0 then
			local rc=rg:GetFirst()
			while rc do
				if rc:GetFlagEffect(5646600)<15 then
					rc:RegisterFlagEffect(5646600,0,0,0)
				end
				rc:ResetFlagEffect(646600)
				rc:RegisterFlagEffect(646600,0,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(75646600,rc:GetFlagEffect(5646600)))	
				rc=rg:GetNext()
			end
		end
	end
end