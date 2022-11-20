--煌怒大狼
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local s,id,o = GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,10133001)
	rscf.SetSummonCondition(c,false,s.slimit)
	local e1 = rscf.AddSpecialSummonProcdure(c,LOCATION_EXTRA,s.sprcon,s.sprtg,s.sprop)
	e1:SetValue(SUMMON_VALUE_SELF)
	local e2 = rsef.SV_Card(c,"atk+",s.aval,"sr",LOCATION_MZONE)
	local e3 = rsef.SV_Card(c,"def+",s.aval,"sr",LOCATION_MZONE)
	local e4 = rsef.STO(c,EVENT_ATTACK_ANNOUNCE,"sp",nil,"sp",nil,nil,nil,
		rsop.target2(s.reg,s.spfilter,"dum",
		LOCATION_EXTRA+LOCATION_DECK+LOCATION_HAND),s.spop)
	if s.switch then return end
	s.switch = true
	local ge1 = rsef.FC_Global(0,EVENT_CHAIN_SOLVING,id,nil,s.regop)
	local ge2 = rsef.FC_Global(0,EVENT_CHAIN_SOLVED,id,nil,s.regop2)
	s.CheckCard = nil
	s.Check = false
	s.Destroy_R = Duel.Destroy
end
function s.cfilter(c)
	return (c:IsCode(10133001) or (c:IsType(TYPE_FUSION) and c:IsSetCard(0x3334))) and c:IsFaceup()
end
function s.aval(e,c)
	return Duel.GetMatchingGroupCount(s.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil) * 1000
end
function s.slimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if not s.CheckCard then
		s.CheckCard = Duel.CreateToken(0,4392470)
	end
	local e1 = rsef.FV_Player({e:GetHandler(),tp},"sp~",1,s.smureg(re),{1,1})
	if re:IsHasCategory(CATEGORY_DESTROY) and re:IsActivated() then
		Duel.Destroy = s.Destroy(re,rp,e1)
	end
end
function s.regop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy = s.Destroy_R
end
function s.Destroy(re,rp,se)
	return function(g,...)
		Duel.IsPlayerCanSpecialSummon(tp,0,POS_FACEUP,tp,s.CheckCard)
		se:Reset()
		if s.Check then
			for tc in aux.Next(rsgf.Mix2(g)) do
				tc:RegisterFlagEffect(id+rp*100,rsrst.std,0,1)
			end
		end
		local arr = {s.Destroy_R(g,...)}
		Duel.Destroy = s.Destroy_R
		s.Check = false
		return table.unpack(arr)
	end
end
function s.smureg(re)
	return function(e,c,sump,sumtype,sumpos,targetp,se)
		if se and se == re then
			s.Check = true
		end
		return false
	end
end
function s.sprcon(e,c,tp)
	return Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_MZONE,0,1,nil,c,e,tp)
end
function s.cfilter2(c,tp)
	return c:GetFlagEffect(id + tp*100) > 0 and c:IsReleasable()
end
function s.cfilter1(c,fc,e,tp)
	if not (c:IsCode(10133001) and c:IsReleasable() and c:IsFaceup()) then return false end
	local g = Duel.GetMatchingGroup(s.cfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,tp)
	g:AddCard(c)
	return #g > 1 and Duel.GetLocationCountFromEx(tp,tp,g,fc) > 0
end
function s.sprtg(e,tp,eg)
	local c=e:GetHandler()
	local g = Group.CreateGroup()
	local cg = Duel.GetMatchingGroup(s.cfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
	local cancle = Duel.IsSummonCancelable()
	local rc = cg:SelectUnselect(g,tp,cancle,false,1,1)
	if not rc then
		return false
	else
		local rg = Duel.GetMatchingGroup(s.cfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,rc,tp)
		rg:AddCard(rc)
		rg:KeepAlive()
		e:SetLabelObject(rg)
		Duel.HintSelection(rg)
		return true
	end
end
function s.sprop(e,tp)
	local rg = e:GetLabelObject()
	Duel.Release(rg,REASON_COST)
end
function s.reg(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spfilter(c,e,tp)
	return (c:IsCode(10133001) or c:IsHasEffect(10133009)) and rscf.spfilter2()(c,e,tp)
end
function s.spop(e,tp)
	rsop.SelectSpecialSummon(tp,s.spfilter,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0,1,1,nil,{},e,tp)
end