if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(s.regcon)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_ADJUST)
		ge0:SetOperation(s.geop)
		Duel.RegisterEffect(ge0,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(s.adjust)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() and Duel.GetMZoneCount(tp,e:GetHandler())>1 end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.filter(c,e,tp)
	return c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg,2,2)
end
function s.mfilter1(c,mg,exg)
	return mg:IsExists(s.mfilter2,1,c,c,exg)
end
function s.mfilter2(c,mc,exg)
	return exg:IsExists(Card.IsXyzSummonable,1,nil,Group.FromCards(c,mc))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	local exg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and mg:IsExists(s.mfilter1,1,nil,mg,exg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local mg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	local exg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:FilterSelect(tp,s.mfilter1,1,1,nil,mg,exg)
	local tc1=sg1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=mg:FilterSelect(tp,s.mfilter2,1,1,tc1,tc1,exg)
	sg1:Merge(sg2)
	if #sg1<2 then return end
	Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
	Duel.AdjustAll()
	if sg1:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<2 then return end
	local xyzg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,sg1)
	end
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_XYZ) and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCountLimit(1)
	e1:SetLabel(rp,Duel.GetCurrentChain())
	e1:SetLabelObject(re)
	e1:SetOperation(s.acop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffectLabel(tp,id)
	Duel.SetFlagEffectLabel(tp,id,ct+1)
	local te=e:GetLabelObject()
	local p,chainc=e:GetLabel()
	Duel.RaiseEvent(Group.FromCards(te:GetHandler()),EVENT_CUSTOM+id,te,REASON_COST,p,tp,chainc)
end
function s.geop(e,tp,eg,ep,ev,re,r,rp)
	if not s.check then
		s.check=true
		Duel.RegisterFlagEffect(0,id,0,0,0,0)
		Duel.RegisterFlagEffect(1,id,0,0,0,0)
		s.OAe={}
	end
	local g=Duel.GetMatchingGroup(function(c)return c:GetType()&0x20004==0x20004 and c:GetActivateEffect()end,0,LOCATION_DECK,LOCATION_DECK,nil)
	for tc in aux.Next(g) do
		local le={tc:GetActivateEffect()}
		for i,v in pairs(le) do
			if v:GetRange()&0x10a~=0 and not SNNM.IsInTable(v,s.OAe) then
				table.insert(s.OAe,v)
				local e1=v:Clone()
				local tg=v:GetTarget() or aux.TRUE
				e1:SetTarget(s.chtg(tg))
				e1:SetRange(LOCATION_DECK)
				e1:SetHintTiming(TIMING_CHAIN_END)
				tc:RegisterEffect(e1,true)
				local e2=SNNM.Act(tc,e1)
				e2:SetRange(LOCATION_DECK)
				e2:SetCost(s.costchk)
				e2:SetOperation(s.costop)
				tc:RegisterEffect(e2,true)
			end
		end
	end
end
function s.evalue(e,re,rp)
	return SNNM.IsInTable(re,s.CAe)
end
function s.chtg(_tg)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_CUSTOM+id,true)
				if not res then return false end
				if chkc then return _tg(e,tp,eg,ep,ev,re,r,rp,0,chkc) and chkc==teg:GetFirst() end
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
				e1:SetTargetRange(0x3c,0x3c)
				e1:SetLabelObject(teg:GetFirst())
				e1:SetTarget(s.efftg)
				e1:SetValue(s.evalue)
				e1:SetReset(RESET_CHAIN)
				Duel.RegisterEffect(e1,tp)
				if chk==0 then
					local pro1,pro2=e:GetProperty()
					local res1=pro1&EFFECT_FLAG_CARD_TARGET~=0
					local f1=Duel.IsExistingTarget
					Duel.IsExistingTarget=function(...)
						res1=true
						return f1(...)
					end
					local f2=Card.IsCanBeEffectTarget
					Card.IsCanBeEffectTarget=function(...)
						res1=true
						return f2(...)
					end
					local res2=_tg(e,tp,eg,ep,ev,re,r,rp,0)
					Duel.IsExistingTarget=f1
					Card.IsCanBeEffectTarget=f2
					return res1 and res2
				end
				_tg(e,tp,eg,ep,ev,re,r,rp,1)
				e1:Reset()
			end
end
function s.efftg(e,c)
	return c~=e:GetLabelObject()
end
function s.evalue(e,re,rp)
	return rp==e:GetHandlerPlayer() and re:GetHandler()==e:GetHandler() and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffectLabel(tp,id)
	return ct>0 and Duel.CheckEvent(EVENT_CUSTOM+id)
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffectLabel(tp,id)
	Duel.SetFlagEffectLabel(tp,id,ct-1)
	SNNM.BaseActOp(e,tp,eg,ep,ev,re,r,rp)
end
function s.adjust(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckEvent(EVENT_CUSTOM+id) then return end
	Duel.SetFlagEffectLabel(0,id,0)
	Duel.SetFlagEffectLabel(1,id,0)
end
