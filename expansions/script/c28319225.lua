--激奏的古之钥 月冈恋钟
function c28319225.initial_effect(c)
	--antica spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28319225,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_DRAW_PHASE)
	e1:SetCountLimit(2,EFFECT_COUNT_CODE_CHAIN)
	e1:SetTarget(c28319225.sptg)
	e1:SetOperation(c28319225.spop)
	c:RegisterEffect(e1)
	--fusion summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28319225,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_DRAW_PHASE)
	e2:SetCountLimit(2,EFFECT_COUNT_CODE_CHAIN)
	e2:SetTarget(c28319225.fstg)
	e2:SetOperation(c28319225.fsop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(28319225,2))
	e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_CUSTOM+28319225)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e3:SetCondition(c28319225.thcon)
	e3:SetTarget(c28319225.thtg)
	e3:SetOperation(c28319225.thop)
	c:RegisterEffect(e3)
	--check
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PREDRAW)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(0xff)
	e4:SetCountLimit(1,28319225+EFFECT_COUNT_CODE_DUEL)
	e4:SetCondition(c28319225.condition)
	e4:SetOperation(c28319225.operation)
	c:RegisterEffect(e4)
	if not c28319225.global_check then
		c28319225.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		--ge1:SetCondition(c28319225.checkcon)
		ge1:SetOperation(c28319225.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c28319225.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Clone()
	g:KeepAlive()
	if eg:IsExists(Card.IsSummonPlayer,1,nil,0) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetLabel(0)
		e1:SetLabelObject(g)
		e1:SetOperation(c28319225.regop)
		Duel.RegisterEffect(e1,tp)
	end
	if eg:IsExists(Card.IsSummonPlayer,1,nil,1) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetLabel(1)
		e1:SetLabelObject(g)
		e1:SetOperation(c28319225.regop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c28319225.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	Duel.RaiseEvent(g,EVENT_CUSTOM+28319225,e,0,0,e:GetLabel(),0)
	g:DeleteGroup()
	e:Reset()
end
function c28319225.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	if Duel.GetLP(tp)>3000 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,2000)
	end
	--Duel.SetChainLimit(c28319225.limit(e:GetHandler()))
end
function c28319225.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c28319225.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	if Duel.GetLP(tp)>3000 then
		Duel.Damage(tp,2000,REASON_EFFECT)
	end
end
function c28319225.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c28319225.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c28319225.fcheck(tp,sg,fc)
	return sg:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DARK)
end
function c28319225.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		aux.FCheckAdditional=c28319225.fcheck
		local res=Duel.IsExistingMatchingCard(c28319225.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c28319225.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		aux.FCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c28319225.fsop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c28319225.filter1,nil,e)
	aux.FCheckAdditional=c28319225.fcheck
	local sg1=Duel.GetMatchingGroup(c28319225.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c28319225.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	aux.FCheckAdditional=nil
end
function c28319225.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(Card.IsSummonPlayer,1,nil,tp)
end
function c28319225.thfilter(c)
	return c:IsSetCard(0x285) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28319225.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c28319225.thop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	if Duel.GetLP(tp)<=3000 and Duel.IsExistingMatchingCard(c28319225.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28319225,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c28319225.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c28319225.condition(e,c)
	return not e:GetHandler():IsPublic()
end
function c28319225.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_DECK) then
		local seq=c:GetSequence()
		Duel.DisableShuffleCheck()
		Duel.MoveSequence(c,SEQ_DECKTOP)
		Duel.ConfirmDecktop(tp,1)
		Duel.DisableShuffleCheck()
		Duel.MoveSequence(c,seq)
	else
		Duel.ConfirmCards(1-tp,c)
	end
	Duel.Hint(HINT_CARD,0,28319225)
	--activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28319225,4))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x285))
	e1:SetTargetRange(LOCATION_HAND,0)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCondition(c28319225.actcon)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	Duel.RegisterEffect(e2,tp)
end
function c28319225.actcon(e)
	return Duel.GetTurnPlayer()==1-e:GetHandlerPlayer()
end
