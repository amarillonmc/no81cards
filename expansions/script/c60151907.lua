--魔铳 终结之魔炮
function c60151907.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,60151907+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(c60151907.e1con)
    e1:SetOperation(c60151907.e1op)
    c:RegisterEffect(e1)
end
function c60151907.e1confilter(c)
    return c:IsFaceup() and c:IsSetCard(0xab26) and c:GetLeftScale()>0
end
function c60151907.e1con(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(c60151907.e1confilter,tp,LOCATION_PZONE,0,1,nil) 
		and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and not Duel.CheckPhaseActivity()
end
function c60151907.e1opfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xab26) and c:GetLeftScale()>0
end
function c60151907.e1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local lsc=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
    local rsc=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local lscs=0
	local rscs=0
	if lsc then lscs=lsc:GetLeftScale() end
	if rsc then rscs=rsc:GetLeftScale() end
    if lscs>rscs then lscs,rscs=rscs,lscs end
	local kds=lscs+rscs
	if kds<=0 then return end
    if Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			if g:GetFirst():IsFacedown() then
				Duel.ConfirmCards(tp,g)
			end
			if lsc then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LSCALE)
				e1:SetValue(0)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
				lsc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_CHANGE_RSCALE)
				lsc:RegisterEffect(e2)
				lsc:RegisterFlagEffect(60151901,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,aux.Stringid(60151903,0))
			end
			if rsc then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LSCALE)
				e1:SetValue(0)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
				rsc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_CHANGE_RSCALE)
				rsc:RegisterEffect(e2)
				rsc:RegisterFlagEffect(60151901,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,aux.Stringid(60151903,0))
			end
			local atk=g:GetFirst():GetAttack()
			local def=g:GetFirst():GetDefense()
			if g:GetFirst():IsAttackPos() and atk<=kds*800 then
				Duel.Hint(HINT_CARD,0,60151907)
				Duel.SendtoGrave(g,REASON_RULE)
				Duel.Damage(1-tp,(kds*800)-atk,REASON_EFFECT)
			elseif g:GetFirst():IsDefensePos() and def<=kds*800 then
				Duel.Hint(HINT_CARD,0,60151907)
				Duel.SendtoGrave(g,REASON_RULE)
				Duel.Damage(1-tp,(kds*800)-def,REASON_EFFECT)
			end
		end
	else
		if lsc then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LSCALE)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			lsc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CHANGE_RSCALE)
			lsc:RegisterEffect(e2)
			lsc:RegisterFlagEffect(60151901,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,aux.Stringid(60151903,0))
		end
		if rsc then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LSCALE)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			rsc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CHANGE_RSCALE)
			rsc:RegisterEffect(e2)
			rsc:RegisterFlagEffect(60151901,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,aux.Stringid(60151903,0))
		end
		Duel.Hint(HINT_CARD,0,60151907)
		Duel.Damage(1-tp,kds*500,REASON_EFFECT)
	end
	Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
    Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
end
function c60151907.skipcon(e)
    return Duel.GetTurnCount()~=e:GetLabel()
end
