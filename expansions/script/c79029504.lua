--混沌虚幻力场·死域
function c79029504.initial_effect(c)
	 c:EnableCounterPermit(0x13)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
	--rank up 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029504,0))
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,79029504) 
	e2:SetCost(c79029504.rkcost)
	e2:SetTarget(c79029504.rktg)
	e2:SetOperation(c79029504.rkop)
	c:RegisterEffect(e2)
	--indens
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79029504,1))
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_BATTLE_START)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,19029504) 
	e3:SetCondition(c79029504.idcon)
	e3:SetCost(c79029504.idcost)
	e3:SetTarget(c79029504.idtg)
	e3:SetOperation(c79029504.idop)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_GRAVE+LOCATION_FZONE)
	e4:SetCountLimit(1,29029504)
	e4:SetTarget(c79029504.reptg)
	e4:SetValue(c79029504.repval)
	e4:SetOperation(c79029504.repop)
	c:RegisterEffect(e4)
end
function c79029504.rkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c79029504.filter1(c,e,tp)
	local m=_G["c"..c:GetCode()]
	return c:IsFaceup() and (c:IsSetCard(0x48) or c:IsSetCard(0x1048)) and m
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c79029504.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank()+1,m.xyz_number)
end
function c79029504.filter2(c,e,tp,mc,rk,no)
	return c:IsRankAbove(rk) and c:IsSetCard(0x2048) and c.xyz_number==no and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c79029504.rktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c79029504.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c79029504.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c79029504.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79029504.rkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local m=_G["c"..tc:GetCode()]
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL)
		or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) or not m then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79029504.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1,m.xyz_number)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,true,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
function c79029504.idcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function c79029504.idcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c79029504.idtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x2048) end 
end 
function c79029504.idop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x2048)
	if g:GetCount()>0 then 
	local tc=g:GetFirst()  
	while tc do 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c79029504.efilter)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	e1:SetOwnerPlayer(tp)
	tc:RegisterEffect(e1)
	tc=g:GetNext()
	end
	end
end
function c79029504.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c79029504.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x2048) and c:IsType(TYPE_MONSTER)
		and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c79029504.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c79029504.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c79029504.repval(e,c)
	return c79029504.repfilter(c,e:GetHandlerPlayer())
end
function c79029504.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end




