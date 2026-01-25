--元素百科全书-地之卷
--1200175
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,5))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(s.tdcon)
	e3:SetTarget(s.tdtg)
	e3:SetOperation(s.tdop)
	c:RegisterEffect(e3)
	--cannot summon,spsummon,flipsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetCondition(s.condition)
	e4:SetTarget(s.sumlimit)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e6)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetCondition(s.checkcon)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		--adjust
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetOperation(s.adjustop)
		Duel.RegisterEffect(ge2,0)
	end
	
end
s[0]=0
s[1]=0
function s.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return (sc and sc:IsSetCard(0x5240))
end
function s.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x5240)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0x5240) and tc:IsType(TYPE_SYNCHRO) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),id,RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function s.studyfilter(c,tp)
	return c:IsCode(1200200) and c.studycon(c,tp)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local count=Duel.GetFlagEffect(tp,id)+1
	local study=Duel.IsExistingMatchingCard(s.studyfilter,tp,LOCATION_MZONE,0,1,nil,tp)
	if count>=2 or study then
		--cannot be material
		local e11=Effect.CreateEffect(c)
		e11:SetReset(RESET_EVENT+RESETS_STANDARD)
		e11:SetType(EFFECT_TYPE_SINGLE)
		e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e11:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e11:SetRange(LOCATION_MZONE)
		e11:SetValue(1)
		c:RegisterEffect(e11)
		--local e12=e11:Clone()
		--e12:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		--c:RegisterEffect(e12)
		--local e13=e11:Clone()
		--e13:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		--c:RegisterEffect(e13)
		local e14=e11:Clone()
		e14:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e14:SetValue(s.fuslimit)
		c:RegisterEffect(e14)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
	end
	if count>=3 or study then
		--immune
		local e2=Effect.CreateEffect(c)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(s.efilter)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
	end
	if count>=4 or study then
	
		--destroy
		local e3=Effect.CreateEffect(c)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetDescription(aux.Stringid(id,6))
		e3:SetCategory(CATEGORY_DESTROY)
		e3:SetType(EFFECT_TYPE_QUICK_O)
		e3:SetCode(EVENT_FREE_CHAIN)
		e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e3:SetRange(LOCATION_MZONE)
		e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
		e3:SetCountLimit(1)
		e3:SetTarget(s.destg)
		e3:SetOperation(s.desop)
		c:RegisterEffect(e3)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
	end
	if count>=5 or study then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
	end
	if count==6 or study then
		--mark
		local e4=Effect.CreateEffect(c)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(id)
		e4:SetRange(LOCATION_MZONE)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e4:SetTargetRange(1,1)
		e4:SetCondition(aux.TRUE)
		c:RegisterEffect(e4)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4))
	end
end

function s.tdfilter(c)
	return c:IsSetCard(0x5240) and c:IsAbleToDeck()
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFlagEffect(tp,id)>=4 or Duel.IsExistingMatchingCard(s.studyfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,0x3e,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),tp,0x3e)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,0x3e,0,aux.ExceptThisCard(e))
	if aux.NecroValleyNegateCheck(g) then return end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function s.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function s.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		if tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end


function s.limfilter(c)
	return c:IsFaceup() and c:IsStatus(STATUS_EFFECT_ENABLED)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(0,id)
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	if sumpos and bit.band(sumpos,POS_FACEDOWN)>0 then return false end
	local rc=s.getrace(Duel.GetMatchingGroup(s.limfilter,targetp or sump,LOCATION_MZONE,0,nil))
	if rc==0 then return false end
	return c:GetRace()~=rc
end
function s.getrace(g)
	local arc=0
	local tc=g:GetFirst()
	while tc do
		arc=bit.bor(arc,tc:GetRace())
		tc=g:GetNext()
	end
	return arc
end
function s.rmfilter(c,rc)
	return c:GetRace()==rc
end
function s.isonlyone(val)
	return val&(val-1)==0
end
function s.tgselect(sg,g)
	local rac=s.getrace(g-sg)
	return rac>0 and s.isonlyone(rac) and not sg:IsExists(s.rmfilter,1,nil,rac)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(0,id) then
		s[0]=0
		s[1]=0
		return
	end
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local c=e:GetHandler()
	if g1:GetCount()==0 then s[tp]=0
	else
		local rac=s.getrace(g1)
		if bit.band(rac,rac-1)~=0 then
			if s[tp]==0 or bit.band(s[tp],rac)==0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local sg=g1:SelectSubGroup(tp,s.tgselect,false,1,#g1,g1)
				if not sg then
					rac=0
				else
					rac=s.getrace(g1-sg)
				end
			else rac=s[tp] end
		end
		g1:Remove(s.rmfilter,nil,rac)
		s[tp]=rac
	end
	if g2:GetCount()==0 then s[1-tp]=0
	else
		local rac=s.getrace(g2)
		if bit.band(rac,rac-1)~=0 then
			if s[1-tp]==0 or bit.band(s[1-tp],rac)==0 then
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
				local sg=g2:SelectSubGroup(1-tp,s.tgselect,false,1,#g2,g2)
				if not sg then
					rac=0
				else
					rac=s.getrace(g2-sg)
				end
			else rac=s[1-tp] end
		end
		g2:Remove(s.rmfilter,nil,rac)
		s[1-tp]=rac
	end
	g1:Merge(g2)
	if g1:GetCount()>0 then
		Duel.SendtoGrave(g1,REASON_RULE)
		Duel.Readjust()
	end
end