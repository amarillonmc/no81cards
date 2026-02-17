--午夜战栗·满月影院
function c10200060.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--①：从手卡·墓地特殊召唤午夜战栗怪兽，结束阶段回手卡
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10200060,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,10200060)
	e1:SetTarget(c10200060.sptg)
	e1:SetOperation(c10200060.spop)
	c:RegisterEffect(e1)
	--②：不死族怪兽移动或表示形式变更时弹回对方同纵列卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10200060,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+0xe25)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,10200061)
	e2:SetCondition(c10200060.thcon)
	e2:SetTarget(c10200060.thtg)
	e2:SetOperation(c10200060.thop)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_CHANGE_POS)
	e2b:SetCondition(c10200060.thcon2)
	c:RegisterEffect(e2b)
end
--①效果
function c10200060.spfilter(c,e,tp)
	return c:IsSetCard(0xe25) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10200060.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10200060.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c10200060.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10200060.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		local tc=g:GetFirst()
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
			--结束阶段回手卡
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCountLimit(1)
			e1:SetLabelObject(tc)
			e1:SetCondition(c10200060.retcon)
			e1:SetOperation(c10200060.retop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c10200060.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup()
end
function c10200060.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
--②效果
function c10200060.cfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:IsControler(tp)
end
function c10200060.thcon(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c10200060.cfilter,nil,tp)
	if #g==0 then return false end
	e:SetLabelObject(g)
	return true
end
function c10200060.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(function(c,tp) return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:IsControler(tp) end,nil,tp)
	if #g==0 then return false end
	e:SetLabelObject(g)
	return true
end
function c10200060.columnfilter(c,g)
	return g:IsExists(c10200060.samecolumnchk,1,nil,c) and c:IsAbleToHand()
end
function c10200060.samecolumnchk(mc,c)
	if not mc:IsLocation(LOCATION_MZONE) then return false end
	local mseq=mc:GetSequence()
	if mseq>4 then
		if mseq==5 then mseq=1
		elseif mseq==6 then mseq=3 end
	end
	local cseq=c:GetSequence()
	local cloc=c:GetLocation()
	if cloc==LOCATION_MZONE then
		if cseq>4 then
			if cseq==5 then cseq=1
			elseif cseq==6 then cseq=3 end
		end
	elseif cloc==LOCATION_SZONE then
		if cseq>4 then return false end
	end
	return mseq==cseq
end
function c10200060.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=e:GetLabelObject()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and c10200060.columnfilter(chkc,g) end
	if chk==0 then return Duel.IsExistingTarget(c10200060.columnfilter,tp,0,LOCATION_ONFIELD,1,nil,g) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	Duel.SelectTarget(tp,c10200060.columnfilter,tp,0,LOCATION_ONFIELD,1,1,nil,g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_ONFIELD)
end
function c10200060.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
