--电子化天使-B-
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--adjust
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(0xff)
	e0:SetOperation(s.adjustop)
	c:RegisterEffect(e0)
	--change effect type
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD)
	e01:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e01:SetCode(id)
	e01:SetRange(LOCATION_HAND+LOCATION_DECK)
	e01:SetTargetRange(1,0)
	c:RegisterEffect(e01)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.tgcon)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	--copy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(s.cptg)
	e3:SetOperation(s.cpop)
	c:RegisterEffect(e3)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_ONFIELD)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,1-tp,LOCATION_ONFIELD,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_RULE,1-tp)
	end
end
function s.filter(c)
	local typ=c:GetType()
	return c:IsFaceupEx() and c:IsSetCard(0x124) and (typ==TYPE_SPELL or bit.band(typ,0x82)==0x82)
		and c:CheckActivateEffect(false,true,false)
end
function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil):GetFirst()
	local te,ceg,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	tc:CreateEffectRelation(e)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not (te and te:GetHandler():IsRelateToEffect(e)) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end

-------------------------------Global Effect-------------------------------

function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.globle_check then
		s.globle_check=true
		local c=e:GetHandler()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_ACTIVATE_COST)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetCost(s.costchk)
		ge1:SetTargetRange(1,0)
		ge1:SetTarget(s.actarget)
		ge1:SetOperation(s.costop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)
		--
		local g=Duel.GetMatchingGroup(s.actfilter,0,0xff,0xff,nil)
		for tc in aux.Next(g) do
			local te=tc:GetActivateEffect()
			local acttg=te:GetTarget()
			local actop=te:GetOperation()
			--Debug.Message("1")
			--
			local te2=te:Clone()
			te2:SetDescription(aux.Stringid(id,3))
			te2:SetType(EFFECT_TYPE_QUICK_O)
			te2:SetCode(EVENT_FREE_CHAIN)
			te2:SetRange(LOCATION_HAND)
			te2:SetHintTiming(TIMING_BATTLE_PHASE,TIMING_BATTLE_PHASE)
			te2:SetTarget(
			function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				if chk==0 then
					local c=e:GetHandler()
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
					e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e1:SetTargetRange(1,0)
					e1:SetTarget(s.splimit)
					Duel.RegisterEffect(e1,tp)
					s[tp]=1
					local boolean=not acttg or acttg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
					s[tp]=0
					e1:Reset()
					return boolean
				end
				local c=e:GetHandler()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetTargetRange(1,0)
				e1:SetTarget(s.splimit)
				Duel.RegisterEffect(e1,tp)
				s[tp]=1
				acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				s[tp]=0
				e1:Reset()
			end)
			te2:SetOperation(
			function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetTargetRange(1,0)
				e1:SetTarget(s.splimit)
				Duel.RegisterEffect(e1,tp)
				s[tp]=1
				actop(e,tp,eg,ep,ev,re,r,rp)
				s[tp]=0
				e1:Reset()
			end)
			tc:RegisterEffect(te2)
		end
		--
		local Effect_IsHasType=Effect.IsHasType
		function Effect.IsHasType(e,type)
			if e:GetDescription() and e:GetDescription()==aux.Stringid(id,3) then 
				return type&(EFFECT_TYPE_FIELD+EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_ACTIONS)~=0
			end
			return Effect_IsHasType(e,type)
		end
		s[0]=0
		s[1]=0
		s.initialization()
	end
	e:Reset()
end
function s.splimit(e,c)
	return not c:IsCode(id)
end
function s.actfilter(c)
	return bit.band(c:GetType(),0x82)==0x82
end
function s.costchk(e,te_or_c,tp)
	local ph=Duel.GetCurrentPhase()
	local b1=ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE 
	local b2=e:GetHandler():IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)
	local b3=Duel.GetCurrentChain()==0
	return Duel.IsPlayerAffectedByEffect(tp,id) and b1 and b2 and b3
end
function s.actarget(e,te,tp)
	local tc=te:GetHandler()
	if te:GetDescription() and te:GetDescription()==(aux.Stringid(id,3)) and bit.band(tc:GetType(),0x82)==0x82 and tc:IsLocation(LOCATION_HAND) then
		e:SetLabelObject(te)
		return true
	end
	return false
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	local tp=te:GetHandlerPlayer()
	--confirm
	local cg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK,0,nil,id)
	if not cg or #cg<=0 then cg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_HAND,0,nil,id) end
	if cg and #cg>0 then Duel.ConfirmCards(1-tp,cg:GetFirst()) end
	--
	if tc:IsType(TYPE_FIELD) then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,false)
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
		if not tc:IsType(TYPE_CONTINUOUS) then
			tc:CancelToGrave(false)
		end
	end
end
function s.initialization()
	--
	if not s.global_select_check2 then
		s.global_select_check2=true
		s[100]=10
		function bit.band(a,b)
			if (a&0x81)==0x81 and (b&0x81)==0x81 then s[s[100]+1]=1
			end
			return a&b
		end
		--
		local _IsCanBeSpecialSummoned=Card.IsCanBeSpecialSummoned
		function Card.IsCanBeSpecialSummoned(card,effect,sumtype,sp,nocheck,nolimit,...)
			if sumtype&SUMMON_TYPE_RITUAL==SUMMON_TYPE_RITUAL and (not s[s[100]+1] or not s[s[100]+1]~=1) then
				s[s[100]+1]=1
			end
			if card:IsType(TYPE_RITUAL) then 
				s[s[100]+2]=1  
			end
			return _IsCanBeSpecialSummoned(card,effect,sumtype,sp,nocheck,nolimit,...)
		end
		local _IsExistingMatchingCard=Duel.IsExistingMatchingCard
		function Duel.IsExistingMatchingCard(func,pl,self,o,num,c_g_n,...)
			s[100]=s[100]+3
			local check=s[100]+1
			s[check]=0
			s[check+1]=0
			local result=_IsExistingMatchingCard(func,pl,self,o,num,c_g_n,...)
			local result2=_IsExistingMatchingCard(func,pl,self|LOCATION_DECK,o,num,c_g_n,...)
			if s[pl] and s[pl]==1 and s[check]==1 and s[check+1]==1 then
				result=result2
			end
			s[check]=0
			s[check+1]=0
			s[100]=s[100]-3
			return result
		end
		--
		local _GetMatchingGroup=Duel.GetMatchingGroup
		function Duel.GetMatchingGroup(func,pl,self,o,c_g_n,...)
			s[100]=s[100]+3
			local check=s[100]+1
			s[check]=0
			s[check+1]=0
			local result=_GetMatchingGroup(func,pl,self,o,c_g_n,...)
			local result2=_GetMatchingGroup(func,pl,self|LOCATION_DECK,o,c_g_n,...)
			if s[pl] and s[pl]==1 and s[check]==1 and s[check+1]==1
				then
				result=result2
			end
			s[check]=0
			s[check+1]=0
			s[100]=s[100]-3
			return result
		end
		--
		local _SelectMatchingCard=Duel.SelectMatchingCard
		function Duel.SelectMatchingCard(spl,func,pl,self,o,min,max,c_g_n,...)
			s[100]=s[100]+3
			local check=s[100]+1
			s[s[100]+1]=0
			s[s[100]+2]=0
			local result=_IsExistingMatchingCard(func,pl,self|LOCATION_DECK,o,min,c_g_n,...)
			if s[pl] and s[pl]==1 and s[check]==1 and s[check+1]==1
				then
				result=_SelectMatchingCard(spl,func,pl,self|LOCATION_DECK,o,min,max,c_g_n,...)
			else
				result=_SelectMatchingCard(spl,func,pl,self,o,min,max,c_g_n,...)
			end
			s[check]=0
			s[check+1]=0
			s[100]=s[100]-3
			return result
		end
	end
end
