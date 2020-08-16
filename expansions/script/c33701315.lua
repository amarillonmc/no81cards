--White Elephant?!
function c33701315.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c33701315.sptg)
	e1:SetOperation(c33701315.spop)
	c:RegisterEffect(e1)	
end
function c33701315.spfil(c,e,tp)
	return c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c33701315.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33701315.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCountFromEx(tp)>0 end
	local g=Duel.SelectMatchingCard(tp,c33701315.spfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_EXTRA)
end
function c33701315.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	if Duel.GetControl(tc,1-tp,PHASE_END,2) then
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetLabel(1-c:GetControler())
	e1:SetTarget(c33701315.retg)
	e1:SetOperation(c33701315.reop)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	tc:RegisterEffect(e2)
	end
end
function c33701315.refil(c,e,cp)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:GetReasonPlayer()==cp
end
function c33701315.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cp=e:GetLabel()
	if chk==0 then return eg:IsExists(c33701315.refil,1,nil,e,cp) end
	local atk=eg:Filter(c33701315.refil,nil,e,cp):GetSum(Card.GetAttack)
	Duel.SetTargetPlayer(1-cp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-cp,atk)
end
function c33701315.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,33701315)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end






