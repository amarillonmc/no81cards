--冰晶光芒 蒂亚
function c72413160.initial_effect(c)
		--atk limit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72413160,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,72413160)
	e1:SetCondition(c72413160.rmcon)
	e1:SetCost(c72413160.rmcost)
	e1:SetOperation(c72413160.rmop)
	c:RegisterEffect(e1)
		--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72413160,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,72413161)
	e2:SetCondition(c72413160.spcon)
	e2:SetTarget(c72413160.sptg)
	e2:SetOperation(c72413160.spop)
	c:RegisterEffect(e2)
	if not c72413160.global_check then
		c72413160.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_DESTROYED)
		ge1:SetCondition(c72413160.regcon)
		ge1:SetOperation(c72413160.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
--
function c72413160.defilter(c,tp)
	return c:IsReason(REASON_BATTLE) and c:IsLocation(LOCATION_GRAVE) and c:GetPreviousControler()==tp
end
function c72413160.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c72413160.defilter,1,nil,tp)
end
function c72413160.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	 
	Duel.RegisterFlagEffect(c:GetControler(),72413161,RESET_PHASE+PHASE_END,0,1)
end
--
function c72413160.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c72413160.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c72413160.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCondition(c72413160.atkcon)
	e1:SetTarget(c72413160.atktg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c72413160.checkop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
end
function c72413160.atkcon(e)
	return e:GetHandler():GetFlagEffect(72413160)~=0
end
function c72413160.atktg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
function c72413160.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(72413160)~=0 then return end
	local fid=eg:GetFirst():GetFieldID()
	e:GetHandler():RegisterFlagEffect(72413160,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	e:GetLabelObject():SetLabel(fid)
end
--
function c72413160.scfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsSynchroSummonable(nil)
end
function c72413160.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandler():GetControler(),72413161)==0
end
function c72413160.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c72413160.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0  and Duel.IsExistingMatchingCard(c72413160.scfilter,tp,LOCATION_EXTRA,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(72413160,0)) then
			local g2=Duel.GetMatchingGroup(c72413160.scfilter,tp,LOCATION_EXTRA,0,nil)
			if g2:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g2:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),nil)
			end
		end
	end
end