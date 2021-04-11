--魔铳 无限之魔弹
function c60151906.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,60151906+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(c60151906.e1con)
    e1:SetOperation(c60151906.e1op)
    c:RegisterEffect(e1)
	--special summon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c60151906.e2tg)
    e2:SetOperation(c60151906.e2op)
    c:RegisterEffect(e2)

end
function c60151906.e1confilter(c)
    return c:IsFaceup() and c:IsSetCard(0xab26) and c:GetLeftScale()>0
end
function c60151906.e1con(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) 
		and Duel.IsExistingMatchingCard(c60151906.e1confilter,tp,LOCATION_PZONE,0,1,nil) 
		and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and not Duel.CheckPhaseActivity()
end
function c60151906.e1opfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xab26) and c:GetLeftScale()>0
end
function c60151906.e1op(e,tp,eg,ep,ev,re,r,rp)
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
	local gw=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,kds,nil)
    if g:GetCount()>0 then
		Duel.HintSelection(g)
		for i=1,g:GetCount() do
            Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151906,0))
			local lb=Duel.SelectMatchingCard(tp,c60151906.e1opfilter,tp,LOCATION_PZONE,0,1,1,nil)
			if lb:GetCount()>0 then
				local lbc=lb:GetFirst()
				local scl=1
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_LSCALE)
				e1:SetValue(-scl)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
				lbc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UPDATE_RSCALE)
				lbc:RegisterEffect(e2)
				lbc:RegisterFlagEffect(60151901,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,aux.Stringid(60151903,0))
			end
        end
		Duel.Destroy(g,REASON_EFFECT)
		local lsc2=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
		local rsc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
		local lscs2=0
		local rscs2=0
		if lsc2 then lscs2=lsc2:GetLeftScale() end
		if rsc2 then rscs2=rsc2:GetLeftScale() end
		if lscs2>rscs2 then lscs2,rscs2=rscs2,lscs2 end
		local kds2=lscs2+rscs2
		if kds2>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)==0 and Duel.SelectYesNo(tp,aux.Stringid(60151906,1)) then
			if lsc2 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LSCALE)
				e1:SetValue(0)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
				lsc2:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_CHANGE_RSCALE)
				lsc2:RegisterEffect(e2)
				lsc2:RegisterFlagEffect(60151901,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,aux.Stringid(60151903,0))
			end
			if rsc2 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LSCALE)
				e1:SetValue(0)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
				rsc2:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_CHANGE_RSCALE)
				rsc2:RegisterEffect(e2)
				rsc2:RegisterFlagEffect(60151901,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,aux.Stringid(60151903,0))
			end
			Duel.Hint(HINT_CARD,0,60151906)
			for i=1,kds2 do
				Duel.Damage(1-tp,500,REASON_EFFECT)
			end
		end
    end
	Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
end
function c60151906.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
    local lsc=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
    local rsc=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local lscs=0
	local rscs=0
	if lsc then lscs=lsc:GetLeftScale() end
	if rsc then rscs=rsc:GetLeftScale() end
    if lscs>rscs then lscs,rscs=rscs,lscs end
	local kds=lscs+rscs
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) and kds>=2 end
    local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c60151906.e2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local lsc=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
    local rsc=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local lscs=0
	local rscs=0
	if lsc then lscs=lsc:GetLeftScale() end
	if rsc then rscs=rsc:GetLeftScale() end
    if lscs>rscs then lscs,rscs=rscs,lscs end
	local kds=lscs+rscs
	if kds<=1 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
		for i=1,2 do
            Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151906,0))
			local lb=Duel.SelectMatchingCard(tp,c60151906.e1opfilter,tp,LOCATION_PZONE,0,1,1,nil)
			if lb:GetCount()>0 then
				local lbc=lb:GetFirst()
				local scl=1
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_LSCALE)
				e1:SetValue(-scl)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
				lbc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UPDATE_RSCALE)
				lbc:RegisterEffect(e2)
				lbc:RegisterFlagEffect(60151901,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,aux.Stringid(60151903,0))
			end
        end
        Duel.Destroy(g,REASON_EFFECT)
    end
end