--伪装兽 恐怖异形
function c35399018.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,c35399018.MatFilter,4,2)
--
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1_1:SetRange(LOCATION_MZONE)
	e1_1:SetValue(aux.tgoval)
	c:RegisterEffect(e1_1)
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetType(EFFECT_TYPE_SINGLE)
	e1_2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1_2:SetRange(LOCATION_MZONE)
	e1_2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1_2:SetValue(1)
	c:RegisterEffect(e1_2)
	local e1_3=e1_2:Clone()
	e1_3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e1_3)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35399018,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,35399018)
	e2:SetTarget(c35399018.tg2)
	e2:SetOperation(c35399018.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(35399018,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c35399018.con3)
	e3:SetOperation(c35399018.op3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(35399018,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c35399018.con4)
	e4:SetOperation(c35399018.op4)
	c:RegisterEffect(e4)
--
end
--
function c35399018.MatFilter(c)
	return c:IsXyzType(TYPE_TUNER) and c:IsRace(RACE_REPTILE)
end
--
function c35399018.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
end
function c35399018.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=Duel.SelectTarget(tp,Card.IsCanOverlay,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	if sg:GetCount()<1 then return end
	local tc=sg:GetFirst()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
		tc:CancelToGrave()
	end
end
--
function c35399018.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>=4
		and rp==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
		and Duel.GetFlagEffect(tp,35399018)<1
end
function c35399018.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(35399018,2)) then
		Duel.RegisterFlagEffect(tp,35399018,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_CARD,0,35399018)
		local rc=re:GetHandler()
		if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
			Duel.Destroy(rc,REASON_EFFECT)
		end
	end
end
--
function c35399018.con4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>=6
		and rp==1-tp and re:IsActiveType(TYPE_MONSTER)
		and Duel.GetFlagEffect(tp,35399019)<1
end
function c35399018.op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(35399018,2)) then
		Duel.RegisterFlagEffect(tp,35399019,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_CARD,0,35399018)
		local rc=re:GetHandler()
		if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
			Duel.Destroy(rc,REASON_EFFECT)
		end
	end
end