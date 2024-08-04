--堕天的古之妖 漆黑幻想颂
function c28366277.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c28366277.cost)
	e1:SetTarget(c28366277.target)
	e1:SetOperation(c28366277.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28366277,3))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c28366277.spcon)
	e2:SetTarget(c28366277.sptg)
	e2:SetOperation(c28366277.spop)
	c:RegisterEffect(e2)
end
function c28366277.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.CheckLPCost(tp,2000)
	local b2=Duel.GetLP(tp)<=3000 and Duel.CheckLPCost(tp,500)
	local b3=Duel.IsPlayerAffectedByEffect(tp,28368431)
	if chk==0 then return b1 or b2 end
	if b3 or not b1 or (b2 and Duel.SelectYesNo(tp,aux.Stringid(28366277,0))) then
		Duel.PayLPCost(tp,500)
	else
		Duel.PayLPCost(tp,2000)
	end
end
function c28366277.thfilter(c)
	return c:IsSetCard(0x285) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28366277.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28366277.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c28366277.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c28366277.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		if Duel.GetLP(tp)<=3000 and tc:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(28366277,1)) then
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_CHANGE_RACE)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD)
			e0:SetValue(RACE_FIEND)
			tc:RegisterEffect(e0)
			Duel.SpecialSummonComplete()
		elseif Duel.GetLP(tp)>3000 then
			local fid=tc:GetFieldID()
			tc:RegisterFlagEffect(9822220,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(28366277,2))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetReset(RESET_PHASE+RESETS_STANDARD+RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetCategory(CATEGORY_DAMAGE)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
			e2:SetCode(EVENT_SPSUMMON_SUCCESS)
			e2:SetProperty(EFFECT_FLAG_DELAY)
			e2:SetRange(LOCATION_HAND)
			e2:SetLabel(fid)
			e2:SetLabelObject(tc)
			e2:SetCondition(c28366277.dacon)
			e2:SetTarget(c28366277.datg)
			e2:SetOperation(c28366277.daop)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
end
function c28366277.dacon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:IsPublic() and tc:GetFlagEffectLabel(9822220)==e:GetLabel() and eg:IsExists(Card.IsControler,1,nil,tp)
end
function c28366277.datg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,e:GetHandler():GetAttack())
end
function c28366277.daop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Damage(tp,tc:GetAttack(),REASON_EFFECT)
	if Duel.GetLP(tp)<=3000 then
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_CHANGE_RACE)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		e0:SetValue(RACE_FIEND)
		tc:RegisterEffect(e0)
	end
end
function c28366277.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=3000 and eg:IsExists(Card.IsControler,1,nil,tp)
end
function c28366277.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) and Duel.IsPlayerCanSpecialSummonMonster(tp,28366277,0x285,TYPES_NORMAL_TRAP_MONSTER,1600,1650,3,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c28366277.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
	end
	if Duel.Destroy(g,REASON_EFFECT)==0 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,28366277,0x285,TYPES_NORMAL_TRAP_MONSTER,1600,1650,3,RACE_FIEND,ATTRIBUTE_DARK) then
		Duel.BreakEffect()
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_SETCODE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(0x283)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e2:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end
