--撒野 绚丽
local s,id,o=GetID()
function s.initial_effect(c)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.splimit)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1118)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		s.saya_code_2={[0]={}, [1]={}}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(s.resetop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		s.saya_code_2[p]={}
	end
end
function s.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x19d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then 
		local ch=Duel.GetCurrentChain()
		if ch>1 then
			local p=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_PLAYER)
			if p==1-tp and Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsType(TYPE_XYZ) end,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
				Duel.BreakEffect()
				Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
				local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsType(TYPE_XYZ) end,tp,LOCATION_MZONE,0,nil)
				for tc in aux.Next(g) do
					tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
					if tc:GetFlagEffect(id+2)==0 then
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_IMMUNE_EFFECT)
						e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
						e1:SetValue(s.efilter)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
						e1:SetRange(LOCATION_MZONE)
						e1:SetOwnerPlayer(tp)
						tc:RegisterEffect(e1)
						tc:RegisterFlagEffect(id+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
					end
				end
				Duel.AdjustInstantly(c)
			end
		end
	end
end
function s.efilter(e,re)
	local res=re:IsActivated() and re:GetOwnerPlayer()~=e:GetHandlerPlayer()
	if res then e:GetHandler():RegisterFlagEffect(id+o,RESET_PHASE+PHASE_END,0,1) end
	local ct1=e:GetHandler():GetFlagEffect(id)
	local ct2=e:GetHandler():GetFlagEffect(id+o)
	if ct1>=ct2 then
		return res
	else
		return false
	end
end
function s.thfilter(c,p)
	return c:IsSetCard(0x9a7d) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and not s.saya_code_2[p][c:GetCode()]
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) and
	Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.Hint(HINT_CARD,0,id)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp)
		if g:GetCount()>0 then
			if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
				local tc=g:GetFirst()
				Duel.ConfirmCards(1-tp,tc)
				if tc:IsLocation(LOCATION_HAND) then
					local code=tc:GetCode()
					local p=tc:GetControler()
					s.saya_code_2[p][code]=true
				end
			end
		end
	end
end