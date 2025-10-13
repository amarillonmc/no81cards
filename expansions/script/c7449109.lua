--异种虫女王
function c7449109.initial_effect(c)
	aux.AddCodeList(c,7449105)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c7449109.eqtg)
	e1:SetOperation(c7449109.eqop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(7449109,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e3:SetCountLimit(1,7449109)
	e3:SetCondition(c7449109.spcon)
	e3:SetTarget(c7449109.sptg)
	e3:SetOperation(c7449109.spop)
	c:RegisterEffect(e3)
	if not c7449109.global_check then
		c7449109.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		--ge1:SetCondition(c7449109.checkcon)
		ge1:SetOperation(c7449109.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end
function c7449109.eqfilter(c,ec,chk)
	return c:IsCode(7449115) and c:CheckEquipTarget(ec) and (chk==0 or aux.NecroValleyFilter()(c))
end
function c7449109.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c7449109.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e:GetHandler(),0) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c7449109.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tid=Duel.GetTurnCount()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(tp,c7449109.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,c,1):GetFirst()
	if tc and Duel.Equip(tp,tc,c) and Duel.GetFlagEffect(tp,7449106+tid*2)~=0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,200,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Damage(1-tp,200,REASON_EFFECT)
	end
end
function c7449109.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 and ev==200
end
function c7449109.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetChainLimit(aux.FALSE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c7449109.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c7449109.ctfilter(c)
	return c:IsCode(7449105) and c:IsFaceup()
end
function c7449109.chkfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsCode(7449105)
end
function c7449109.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c7449109.ctfilter,1,nil)
end
function c7449109.checkop(e,tp,eg,ep,ev,re,r,rp)
	--local sg=eg:Filter(c7449109.ctfilter,nil)
	local tid=Duel.GetTurnCount()
	for p=0,1 do
		local tc=eg:GetFirst()
		while tc do
			if c7449109.chkfilter(tc,p) then
				--Debug.Message(tid)
				--Debug.Message(7449108+tid*2)
				Duel.RegisterFlagEffect(p,7449108+tid*2,RESET_PHASE+PHASE_END,0,2)
			end
			tc=eg:GetNext()
		end
	end
	--[[for tc in aux.Next(sg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_DRAW)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(c7449109.regcon)
		e1:SetOperation(c7449109.regop)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tc:GetSummonPlayer())
	end]]
end
function c7449109.regcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c7449109.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,7449109,RESET_PHASE+PHASE_END,0,1)
end
