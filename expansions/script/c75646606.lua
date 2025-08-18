--逆熵科技 蛙型发信器
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,75646600)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)  
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,id-70000000)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(s.drcon1)
	e3:SetOperation(s.drop1)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	--sp_summon effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(s.regcon)
	e4:SetOperation(s.regop)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetCondition(s.drcon2)
	e5:SetOperation(s.drop2)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.thcon2)
	e2:SetOperation(s.thop2)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	
	local e6=e3:Clone()
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	Duel.RegisterEffect(e6,tp)
	local e7=e4:Clone()
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	Duel.RegisterEffect(e7,tp)
end
function s.tgfilter(c,tp)
	return c:IsControler(tp) and aux.IsCodeListed(c,75646600) and not c:IsCode(id)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.tgfilter,1,e:GetHandler(),tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and (eg:IsExists(Card.IsCode,1,nil,75646600) or Duel.GetFlagEffect(tp,75646600)>0) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) and #sg>0 then
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,0,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)  
		end
	end
end
function s.filter(c,sp)
	return c:IsSummonPlayer(sp)
end
function s.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter,1,nil,1-tp)
		and not Duel.IsChainSolving()
end
function s.drop1(e,tp,eg,ep,ev,re,r,rp)
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
	if Duel.GetFlagEffect(tp,75646600)~=0 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end 
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter,1,nil,1-tp)
		and Duel.IsChainSolving()
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
end
function s.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>0
end
function s.drop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,id)
	Duel.ResetFlagEffect(tp,id)
	for i=1,n do
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
		if Duel.GetFlagEffect(tp,75646600)~=0 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end

function s.thfilter2(c,chk)
	return (c:IsCode(75646600) or (chk>0 and aux.IsCodeListed(c,75646600))) and c:IsAbleToHand() and c:IsFaceupEx() 
end
function s.thcon2(e,tp,eg,ep,ev,re,r,rp)	
	local ct1=Duel.GetFlagEffect(tp,75646600)
	return Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ct1)
end
function s.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local ct1=Duel.GetFlagEffect(tp,75646600)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter2),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,ct1)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
