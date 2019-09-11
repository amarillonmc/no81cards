--你已经疯了！
function c11200023.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c11200023.mfilter,3,true)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11200023,0))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,11200023)
	e1:SetCondition(c11200023.con1)
	e1:SetTarget(c11200023.tg1)
	e1:SetOperation(c11200023.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11200023,0))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11200023)
	e2:SetCondition(c11200023.con2)
	e2:SetTarget(c11200023.tg1)
	e2:SetOperation(c11200023.op1)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TOSS_DICE_NEGATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c11200023.con3)
	e3:SetOperation(c11200023.op3)
	c:RegisterEffect(e3)
--
end
--
c11200023.xig_ihs_0x132=1
--
function c11200023.mfilter(c)
	return c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER)
end
--
function c11200023.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=c:GetMaterial()
	return c:GetMaterialCount()>0 and c:IsSummonType(SUMMON_TYPE_FUSION)
		and not sg:IsExists(Card.IsCode,1,nil,11200019)
end
function c11200023.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=c:GetMaterial()
	return c:GetMaterialCount()>0 and c:IsSummonType(SUMMON_TYPE_FUSION)
		and sg:IsExists(Card.IsCode,1,nil,11200019)
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
--
function c11200023.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
--
function c11200023.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=Duel.TossDice(tp,1)
	if dc>0 and dc<6 then
		if c:IsControler(1-tp) then return end
		if c:IsImmuneToEffect(e) then return end
		if Duel.GetMZoneCount(tp)<1 then return end
		if not c:IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		local nseq=math.log(s,2)
		Duel.MoveSequence(c,nseq)
		local sg=c:GetColumnGroup(LOCATION_MZONE)
		local dg=sg:Filter(Card.IsControler,nil,1-tp)
		if dg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
	if dc>5 then Duel.Damage(1-tp,2000,REASON_EFFECT) end
end
--
function c11200023.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION)
		and c:GetFlagEffect(11200023)==0
		and c:GetMaterial():IsExists(Card.IsCode,1,nil,11200065)
end
function c11200023.op3(e,tp,eg,ep,ev,re,r,rp)
	local cc=Duel.GetCurrentChain()
	local cid=Duel.GetChainInfo(cc,CHAININFO_CHAIN_ID)
	if c11200023[0]~=cid and Duel.SelectYesNo(tp,aux.Stringid(11200023,1)) then
		Duel.Hint(HINT_CARD,0,11200023)
		e:GetHandler():RegisterFlagEffect(11200023,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local dc={Duel.GetDiceResult()}
		local ac=1
		local ct=bit.band(ev,0xff)+bit.rshift(ev,16)
		if ct>1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11200023,2))
			local val,idx=Duel.AnnounceNumber(tp,table.unpack(dc,1,ct))
			ac=idx+1
		end
		dc[ac]=7
		Duel.SetDiceResult(table.unpack(dc))
		c11200023[0]=cid
	end
end
