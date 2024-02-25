--恋慕屋敷的泯妖精
function c9911080.initial_effect(c)
	c:SetSPSummonOnce(9911080)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	e1:SetCondition(c9911080.spcon)
	e1:SetTarget(c9911080.sptg)
	e1:SetOperation(c9911080.spop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c9911080.ctcon)
	e2:SetTarget(c9911080.cttg)
	e2:SetOperation(c9911080.ctop)
	c:RegisterEffect(e2)
end
function c9911080.spfilter(c)
	return c:IsFaceup() and c:IsReleasable(REASON_SPSUMMON)
end
function c9911080.spfilter2(c)
	return c:GetOriginalRace()&RACE_FIEND>0 and c:GetOriginalType()&TYPE_MONSTER>0
end
function c9911080.fselect(g,tp)
	return aux.mzctcheck(g,tp) and aux.gffcheck(g,c9911080.spfilter2,nil,Card.IsType,TYPE_FIELD)
end
function c9911080.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c9911080.spfilter,tp,LOCATION_ONFIELD,0,nil)
	return g:CheckSubGroup(c9911080.fselect,2,2,tp)
end
function c9911080.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c9911080.spfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroup(tp,c9911080.fselect,true,2,2,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c9911080.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c9911080.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function c9911080.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,4,0,0x1954)
end
function c9911080.addfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c9911080.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9911080.addfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetAttack)
		local tc
		if tg:GetCount()>1 then
			if tg:IsExists(Card.IsCanAddCounter,1,nil,0x1954,4) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
				local sg=tg:FilterSelect(tp,Card.IsCanAddCounter,1,1,nil,0x1954,4)
				Duel.HintSelection(sg)
				tc=sg:GetFirst()
			end
		elseif tg:GetFirst():IsCanAddCounter(0x1954,4) then
			Duel.HintSelection(tg)
			tc=tg:GetFirst()
		end
		if tc then
			tc:AddCounter(0x1954,4)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
			e1:SetTarget(c9911080.distg)
			e1:SetRange(LOCATION_MZONE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_SOLVING)
			e2:SetOperation(c9911080.disop)
			e2:SetRange(LOCATION_MZONE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e3:SetTarget(c9911080.distg)
			e3:SetRange(LOCATION_MZONE)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3,true)
		end
	end
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(c9911080.splimit)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
end
function c9911080.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x9954) and c:IsLocation(LOCATION_EXTRA)
end
function c9911080.distg(e,c)
	local g=Group.FromCards(c)
	g:Merge(c:GetColumnGroup())
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and g:IsContains(e:GetHandler())
end
function c9911080.disop(e,tp,eg,ep,ev,re,r,rp)
	local tseq=aux.MZoneSequence(e:GetHandler():GetSequence())
	local controller,loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if loc&LOCATION_SZONE~=0 and seq<=4 and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
		and ((controller==tp and seq==tseq) or (controller==1-tp and seq==4-tseq)) then
		Duel.NegateEffect(ev)
	end
end
