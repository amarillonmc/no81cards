--纯白义勇队 安娜
function c75080007.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c75080007.thtg)
	e1:SetOperation(c75080007.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--------
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75080005,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetCountLimit(1,75080007)
	e3:SetCondition(c75080007.spcon)
	e3:SetTarget(c75080007.sptg)
	e3:SetOperation(c75080007.spop)
	c:RegisterEffect(e3)
end
function c75080007.thfilter(c)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsAbleToHand()
end
function c75080007.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local sel=0
		if Duel.GetFlagEffect(tp,75080007)==0 and Duel.IsExistingMatchingCard(c75080007.thfilter,tp,0,LOCATION_ONFIELD,1,nil) then sel=sel+1 end
		if Duel.GetFlagEffect(tp,75080008)==0 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,nil) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(75080007,0))
		sel=Duel.SelectOption(tp,aux.Stringid(75080007,1),aux.Stringid(75080007,2))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(75080007,1))
	else
		Duel.SelectOption(tp,aux.Stringid(75080007,2))
	end
	e:SetLabel(sel)
	if sel==1 then
		Duel.RegisterFlagEffect(tp,75080007,RESET_PHASE+PHASE_END,0,1)
		local g=Duel.GetMatchingGroup(c75080007.thfilter,tp,0,LOCATION_ONFIELD,nil)
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	else
		Duel.RegisterFlagEffect(tp,75080008,RESET_PHASE+PHASE_END,0,1)
		local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c75080007.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c75080007.thfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c75080007.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3754)
end
function c75080007.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
end
function c75080007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c75080007.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end