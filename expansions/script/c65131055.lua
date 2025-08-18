--魔导智能 莫卡罗拉
local s,id,o=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(id)
	e0:SetRange(LOCATION_DECK)
	c:RegisterEffect(e0)
	--hand synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_DECK)
	e1:SetCondition(s.matcon)
	e1:SetOperation(s.matop)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		s.hint_effect={}
		s.hint_effect[1]=Effect.GlobalEffect()
		s.hint_effect[2]=Effect.GlobalEffect()
		local _ConfirmDecktop=Duel.ConfirmDecktop
		function Duel.ConfirmDecktop(tp,num)
			local g=Duel.GetDecktopGroup(tp,num)
			if g:IsExists(Card.IsCode,1,nil,id) then
				Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
				s.resetflag(tp)
			end
			_ConfirmDecktop(tp,num)
		end
	end
end
function s.resetflag(tp)
	s.hint_effect[tp+1]:Reset()
	local num=Duel.GetFlagEffect(tp,id)-Duel.GetFlagEffect(tp,id+1)
	if num<=0 then return end
	if num>6 then num=6 end
	s.hint_effect[tp+1]=Effect.GlobalEffect()
	s.hint_effect[tp+1]:SetDescription(aux.Stringid(id,num))
	s.hint_effect[tp+1]:SetType(EFFECT_TYPE_FIELD) 
	s.hint_effect[tp+1]:SetCode(id)
	s.hint_effect[tp+1]:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	s.hint_effect[tp+1]:SetReset(RESET_PHASE+PHASE_END)
	s.hint_effect[tp+1]:SetTargetRange(1,0) 
	Duel.RegisterEffect(s.hint_effect[tp+1],tp)
end
function s.matcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_DECK,0,nil,id)
	if g:GetMinGroup(Card.GetSequence):GetFirst()~=c or Duel.GetFlagEffect(tp,id)<=Duel.GetFlagEffect(tp,id+1) then return end
	local mg=Duel.GetSynchroMaterial(tp)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	return Duel.GetMatchingGroup(s.scfilter,tp,LOCATION_EXTRA,0,nil,tp,mg,c):GetCount()>0
end
function s.scfilter(c,tp,mg,tc)
	return c:IsRace(RACE_SPELLCASTER) and c:IsSynchroSummonable(tc,mg+tc)
end
function s.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetSynchroMaterial(tp)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	local sg=Duel.GetMatchingGroup(s.scfilter,tp,LOCATION_EXTRA,0,nil,tp,mg,c):CancelableSelect(tp,1,1,nil)
	if sg then
		Duel.SynchroSummon(tp,sg:GetFirst(),c)
		Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
		s.resetflag(tp)
	end
end
function s.matval(e,c)
	return c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_SPELLCASTER)
end